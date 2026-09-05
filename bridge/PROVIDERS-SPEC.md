# PROVIDERS-SPEC — thin provider registry for fit-to-brand (spec, no code yet)

Status: SPEC ONLY (2026-09-05). Nothing here is implemented; `bridge/PROFILES.md`,
Q0.1–Q0.5, and `hooks/ftb.ps1` presets stay normative until a build lands.

## 1. Goal

Replace the preset-table + web-manual-handoff complexity with the industry-standard
three-step setup used by OpenCode, Hermes-agent, Codex, and Antigravity:

1. select a provider, 2. add an API key (env only, never in runs), 3. select a model.

Keep everything already in the repo: the 8 presets in `bridge/PROFILES.md` stay as
fallback notes (web-manual paths, bespoke adapters) alongside the registry, and the
Q0 elicitation spine keeps asking — it just asks *select* questions instead of
toolchain essays.

## 2. What we borrow (researched 2026-09-05, primary sources)

### 2a. OpenCode (`github.com/anomalyco/opencode`)

- Provider record shape (`packages/core/src/v1/config/provider.ts`, JSON-Schema
  `https://opencode.ai/config.json`): `{ npm, name, options: { baseURL, apiKey,
  headers, timeouts }, models: { <id>: { name, tool_call, reasoning, limit,
  modalities, cost } } }`.
- Key references, never values: `options.apiKey: "{env:VAR}"` or `"{file:path}"`
  (`packages/opencode/src/config/variable.ts`); secrets live in process env or
  `auth.json` (mode `0o600`), project config stays committable
  (`opencode.ai/docs/providers`, `opencode.ai/docs/config`).
- Endpoint resolution: one live catalog (`https://models.opencode.ai/api.json`,
  213 provider keys) mapped to SDK constructors; default fallback npm is
  `@ai-sdk/openai-compatible` — plain baseURL+key covers Ollama, LM Studio,
  llama-server, Helicone, and any OpenAI-shaped endpoint
  (`packages/opencode/src/provider/provider.ts`).
- Hard boundary found: OpenCode is **text-only**. No `generateImage/generateVideo`
  path exists (`session/llm.ts` calls `streamText` only); the catalog *describes*
  image/video-output models but nothing calls their generation endpoints.

### 2b. Hermes-agent (`github.com/NousResearch/hermes-agent`, MIT)

- `ProviderProfile` dataclass (`providers/base.py:39`): `name`, `aliases`,
  `env_vars` (key env names), `base_url` + separate `models_url`,
  `auth_type` (`api_key | oauth_device_code | oauth_external | copilot | aws_sdk`),
  capability flags (`supports_vision`, …), `fallback_models` static list,
  `fetch_models()` live probe of `{models_url or base_url}/models`
  (contract: `plugins/model-providers/README.md`, `providers/README.md`).
- ~39 bundled profiles (`plugins/model-providers/<name>/` self-contained plugin +
  `plugin.yaml`); precedence bundled < user-file < explicit config
  (last-writer-wins); `custom` escape hatch (empty `base_url`, no fixed key).
- Keys: env + profile `.env` via `get_env_value_prefer_dotenv()`; multiplex
  isolation (`agent/secret_scope.py` fails closed); redaction on export
  (`agent/redact.py`, `hermes_cli/dump.py`). Full blank-key template in
  `.env.example` (names + signup URLs, values blank).
- Selection semantics worth copying: explicit-config-wins-even-if-unavailable
  (precise errors) vs availability-filtered fallback; ordered
  `fallback_providers` chain with fast-failover retry knob.
- Image/video are **separate pluggable registries** (`agent/image_gen_registry.py`,
  `agent/video_gen_registry.py`; ABC: `name`, `is_available()` key check,
  `list_models()`, `generate()`). Backends: image = fal, openai, openai-codex,
  openrouter, xai, krea, deepinfra; video = fal, xai, deepinfra. Lesson: one thin
  interface per medium, not provider-specific sprawl.
- Leave behind: the dual-registry duplication (profiles vs
  `hermes_cli/auth.py:PROVIDER_REGISTRY` re-declaring the same key/URL data) and
  all chat-platform machinery (`platforms/`, `relay/`, `profile_routing.py`).

## 3. Target design (to build)

### 3a. Registry file: `bridge/PROVIDERS.md`

One table, one row per provider (static, hand-curated — no live catalog fetch;
the repo stays offline-capable):

`| id | aliases | baseURL | keyEnv | images | video | notes |`

- `id`: short key (`openrouter`, `openai`, `google-ai-studio`, `ollama`, …).
- `baseURL`: the OpenAI-compatible base (chat + `/models` probe).
- `keyEnv`: env var name(s) holding the key (values never appear anywhere).
- `images` / `video`: endpoint shape spoken here — `openai-images`
  (`POST {base}/images/generations`, OpenAI shape), `bespoke:<name>` (adapter
  note in PROFILES.md), or `none`.
- `notes`: free-model/test constraints (see §5), signup URL.

Seed rows: `openrouter` (openai-images shape, free `:free` models for tests),
`openai` (openai-images + Sora-bespoke; no free tier — auth-check only),
`google-ai-studio` (Gemini OpenAI-compat base; text free tier; image shape
verified at build), `ollama` (local, keyless, `none` for images), plus a
`custom` row (empty baseURL, no fixed key — Hermes escape hatch).

### 3b. Run record (replaces preset-seeded Q0.1–Q0.5 values, not the questions)

- `PARAMS.log`: `Q0.1 = <provider-id>`, `Q0.2 = <image-provider-id|same|none>`,
  `Q0.3 = <finisher>`, `Q0.4 = <font source>`, `Q0.5 = <cost unit + cap>`,
  plus `Q0.1m = <chat model id>` and `Q0.2m = <image model id>` (model select
  recorded beside provider select).
- `PROFILE.md`: provider ids + model ids + baseURLs + capability flags +
  fallbacks. Keys never appear (not even env var *values* — names only).
- `ftb.ps1 quickstart -Preset` keeps working (presets become registry-backed
  shortcuts); `-Provider` / `-Model` flags added at build time.

### 3c. Hook: `hooks/Test-Provider.ps1 -RunDir <dir>`

1. Key-presence check: named env var set and non-empty (never printed, length
   never logged — PASS/FAIL only).
2. Auth check: `GET {baseURL}/models` with the key; 200 = key valid (no spend).
3. Capability check: named model id present in the response (or registry static
   list when the endpoint has no `/models`).
4. Wired as an H1-style preflight for Generation Plans that spend (plan cites
   `provider:<id>` + `model:<id>`; runner refuses spend on a red provider
   check). Generation cost lines keep pricing against Q0.5 cap as today.

### 3d. Image/video generation mapping (the honest boundary)

Gateways normalize **chat/text**, not pixels. So:

- Where the provider speaks `openai-images` (OpenAI, OpenRouter-routed
  image models): one shared payload builder (prompt, size, n=1, response
  format) + Figma finish as today.
- Where it does not (Midjourney: no API; Firefly, Runway, Sora, Comfy, Veo):
  keep the existing `PROFILES.md` bespoke notes verbatim as the adapter doc.
- Hermes lesson adopted: per-medium thin interface
  (`is_available` = key check, `list_models`, `generate`) documented in the
  registry notes column, not one integration per provider per medium.

## 4. Key handling rules (normative, adopt Hermes + OpenCode practice)

1. Keys live in process env or the platform's secret store. Never in chat,
   runs, reports, logs, memory, or git.
2. Runs and specs reference key *names* (`keyEnv`) and provider/model *ids*.
3. Hooks check presence/validity; they never print values or lengths.
4. Export/redact: any future `dump` command redacts `keyEnv`-named variables.
5. Past keys exposed in chat history are revoked at the dashboard and reissued
   (2026-09-05: three keys pasted in chat — revoked before build).

## 5. Verify-vs-spend rules (per provider, enforced by Test-Provider + plans)

- `openrouter`: tests use `:free`-suffixed models only while the key carries no
  credit; paid models need explicit per-plan approval.
- `google-ai-studio`: free-tier text models testable; image models verified
  (shape + auth) at build, generation tests need approval.
- `openai`: **no free tier exists** — `GET /models` auth-check only; every
  generation is spend and needs Q8.2-style explicit approval with the cap cited.
- `ollama`/local: keyless; spend-safe by construction.

## 6. Build order (when approved)

1. `bridge/PROVIDERS.md` seed registry + `REQUIREMENTS.md` key-env table.
2. `hooks/Test-Provider.ps1` + wire into Generation-Plan spend gates.
3. `ftb.ps1 -Provider/-Model` flags; Q0.1–Q0.5 ask select-questions against
   the registry; `PROFILES.md` kept as fallback notes.
4. Verify per §5 (free/auth-only first), then first real render on approval.

## 7. Q0 questionnaire change spec (exact deltas to `bridge/QUESTIONNAIRES.md`)

Q0.0, Q0.3, Q0.4, Q0.5, Q0.6, Q0.7, Q0.8 are unchanged. Q0.1/Q0.2 become
select-questions against the registry (§3a / Appendix R0); two new keys
carry the model select. `manual` (current preset behavior) stays as an
explicit escape on both, so no run is forced onto API paths.

- **Q0.1 image provider?** Options: registry ids whose `images` ≠ `none`
  (recommended first = registry default, `openrouter`) / `manual` (keep the
  current preset/web-manual path via `PROFILES.md`). → `Q0.1 = <id|manual>`.
- **Q0.1m image model?** Options: the row's static default models
  (recommended first); free-tier-safe default while the key carries no
  credit (per §5). Skipped iff Q0.1 = `manual`. → `Q0.1m = <model-id>`.
- **Q0.2 video provider?** `same-stack` (Q0.1 provider+model drive motion —
  recommended) / registry ids whose `video` ≠ `none` / `none` storyboard
  fallback / `manual`. → `Q0.2`.
- **Q0.2m video model?** Asked iff Q0.2 names a registry id (not
  `same-stack`, not `none`, not `manual`). → `Q0.2m = <model-id>`.
- Entry-lock deltas (`hooks/Enter-Phase.ps1`): phase-0 ask-set gains
  `Q0.1m` (required iff Q0.1 is a registry id) and `Q0.2m` (required iff Q0.2
  is a registry id other than the Q0.1 row). `Test-Params` (H1) checks keys,
  never values — old preset-seeded values keep passing.
- Elicitation modes unchanged: `defaults`/`quickstart` seeds Q0.1 = registry
  default + Q0.1m = its free-safe default (`src=default`); `manual` answers
  keep `src=asked` semantics as today.

## 8. Test-Provider hook spec (`hooks/Test-Provider.ps1`, new file at build)

Single source of truth is the registry Markdown table (§3a) — the hook parses
it (split `|` rows, 8 columns), so there is no second file to drift. Local-only
hook (needs keys): never invoked by CI.

- **Params:** `-RunDir <dir> -Provider <id> [-Model <id>] [-ProbeTimeoutSec 15]`.
- **Checks, in order (stop at first red):**
  1. Registry row `<id>` exists (aliases resolve to the canonical id).
  2. Key presence: every `keyEnv` name set and non-empty. Output is
     PASS/FAIL per name only — values and lengths never printed or logged.
  3. Auth check: `GET {baseURL}{probe}` (default `/models`) with the key;
     200 = key valid. Keyless rows (`keyEnv` = `none`, e.g. local Ollama)
     skip to check 4 with a reachability probe only. This check spends
     nothing (GET only, never a generation).
  4. Model check (iff `-Model`): exact id match in the response `data[].id`
     list, else exact match in the row's static defaults (covers endpoints
     with no `/models`, e.g. some local servers).
- **Output:** `PASS: [P-row]/[P-key]/[P-auth]/[P-model] …` lines,
  `RESULT: GREEN` exit 0, or first `FAIL:` + `RESULT: RED` exit 1 (same
  Say/RESULT dialect as `hooks/Validate-Gates.ps1`).
- **Wiring:** Generation Plans gain `provider: <id>` + `model: <id>` fields;
  a plan is not eligible for Q8.2 spend approval until its provider check is
  green, and the approval line cites it
  (e.g. `H3 GenPlan-kit APPROVED <date> <who> (provider openrouter green)`).
  H1 `Test-Params`/`Test-Sources` are untouched — provider health is
  environmental, not a run artifact, so it stays out of `GATES.log`
  (log the approval, never the probe).

## 9. `ftb.ps1` change spec (deltas only; state machine untouched)

- New optional flags: `quickstart|init -Provider <id> -Model <id>`
  (also `-VideoProvider/-VideoModel`). Seeding writes Q0.1/Q0.1m
  (Q0.2 defaults to `same-stack`) with `src=asked` — choosing is answering,
  same rule as `-Preset` today.
- `-Preset` behavior unchanged; `-Provider` and `-Preset` together is
  BLOCKED (one toolchain source per run). Preset table and `PROFILES.md`
  stay byte-identical (fallback notes, §1).
- `PROFILE.md` gains three lines under the existing declaration:
  `Provider: <id> (<baseURL>)`, `Models: chat <id> / image <id>`,
  `Key: <keyEnv name> in env (value never recorded)`. Manual runs keep the
  current free-text profile.
- No phase-order, STATE.json, or gate-matrix changes.

## 10. Migration and compatibility

- Old runs keep passing: H1 checks keys not values, so preset-seeded Q0.1
  values (`Lovart-native`, …) and free-text PROFILE.md files stay green.
- Registry `notes` column cites the `PROFILES.md` preset name wherever a row
  falls back to web-manual or bespoke adapters (no forked guidance).
- `REQUIREMENTS.md` gains the key-env table at build (one row per registry
  id: env name, where to issue, free-tier note per §5).

## Appendix R0 — seed registry rows (draft data; goes live as `bridge/PROVIDERS.md` at build)

Columns: `id | aliases | baseURL | probe | keyEnv | images | video | defaults | notes`.

| id | aliases | baseURL | probe | keyEnv | images | video | defaults | notes |
|---|---|---|---|---|---|---|---|---|
| openrouter | or | https://openrouter.ai/api/v1 | /models | OPENROUTER_API_KEY | openai-images | bespoke:via-model | chat auto free; image :free image models | tests on `:free` models only while key has no credit (§5) |
| openai | oa | https://api.openai.com/v1 | /models | OPENAI_API_KEY | openai-images | bespoke:sora | chat gpt-4o-mini; image gpt-image-1 | NO free tier: auth-check only, every generation is spend (§5) |
| google-ai-studio | gai | https://generativelanguage.googleapis.com/v1beta/openai/ | /models | GOOGLE_AI_STUDIO_KEY | verify-at-build | verify-at-build | chat gemini-2.0-flash | free-tier text testable; image shape verified at build (§5) |
| ollama | local | http://localhost:11434/v1 | /api/tags | none | none | none | chat per local pull | keyless, spend-safe; image/video stay manual |
| fal | — | https://queue.fal.run | none | FAL_KEY | bespoke:fal | bespoke:fal | image per queue model | image/video-only lane (no chat); Hermes parity row |
| custom | manual-api | (user-configured) | /models | (user-named) | verify-at-build | verify-at-build | (user-set) | escape hatch: empty baseURL, no fixed key (Hermes `custom`) |
| manual | web | — | — | — | manual | manual | — | current preset behavior via PROFILES.md; no keys, no probes |
