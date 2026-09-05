# PROVIDERS-EXAMPLES — five granular runs through the provider registry (companion to PROVIDERS-SPEC.md)

Status: worked examples for the SPEC-ONLY registry design. Nothing here executes;
there is no `bridge/PROVIDERS.md`, no `hooks/Test-Provider.ps1`, and no
`-Provider` flag yet. Each scenario shows the same six beats:
select → key → check → plan → approve → render + actuals.

## Scenario 1 — hobby render on OpenRouter (no credit, free models only)

1. Select: Q0.1 = `openrouter`, Q0.1m = a `:free` image model; Q0.2 =
   `same-stack` (motion follows the image provider); Q0.5 = API-$ cap 30.
2. Key: `OPENROUTER_API_KEY` in env. Only the *name* is recorded in the run.
3. Check: `Test-Provider` — row exists → key present → `GET /models` 200 →
   model id found. GREEN.
4. Plan: KIT-01 cites `provider: openrouter`, cost $0 (free model) + 60
   seat-minutes Figma finishing.
5. Approve: Q8.2 cites the green provider check.
6. Render + actuals: stills generate; $0 + minutes logged vs the cap. Paid
   models stay blocked until one is explicitly approved on its own plan.

## Scenario 2 — client work on OpenAI (paid, no free tier)

1. Select: Q0.1 = `openai`, Q0.1m = `gpt-image-1`; Q0.5 = API-$ cap 30.
2. Key: `OPENAI_API_KEY` in env.
3. Check: `Test-Provider` — `GET /models` 200 proves the key without spending
   a cent (there is no free tier, so this is all testing this key ever gets
   for free).
4. Plan: cites `provider: openai` + per-image estimate; approval is an
   explicit spend decision, never silent.
5. Approve: Q8.2 with the estimate and cap cited.
6. Render + actuals: actuals logged; any plan projecting over the cap goes
   red *before* approval, not after.

## Scenario 3 — fully local with Ollama (no keys, no spend)

1. Select: Q0.1 = `ollama` for text; images stay `manual` (the row declares
   `images: none`, so the questionnaire routes around it honestly).
2. Key: none — `Test-Provider` runs a reachability probe of
   `localhost:11434` only. Nothing to leak, nothing to bill.
3. Plan: text work local; image prompts use the kept `PROFILES.md` fallback
   notes (Figma + web tools), unchanged from today.

## Scenario 4 — no API at all (today's behavior, byte-identical)

1. Select: Q0.1 = `manual`; Q0.1m skipped; pick a `PROFILES.md` preset
   (e.g. `docs`, the self-run path).
2. Check: none runs — there is nothing to verify.
3. Plan: web-manual handoff prompts exactly as today. This is the guaranteed
   fallback: keyless users get the current system unchanged, and old runs
   keep passing H1 (keys, not values, are checked).

## Scenario 5 — studio gateway with fallback (custom endpoint + safety net)

1. Select: Q0.1 = `custom` with the studio's OpenAI-compatible baseURL and
   your named key var.
2. Check: `Test-Provider` probes its `/models`; on red the run records the
   precise error (explicit-config-wins: loud failure, never silent drift).
3. Fallback: ordered backup chain (custom → openrouter-free) with fast
   failover, borrowed from Hermes — a dead endpoint degrades to free models
   instead of killing the run.
4. Spend: whichever provider actually renders bills under its own row rules
   (§5 of the spec); the plan cites the provider that rendered.
