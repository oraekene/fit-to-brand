# platforms/ — per-agent enforcement adapters (the bundle stays agnostic)

Honest layering: no markdown skill can hard-block an arbitrary agent in-chat
(nothing executes between an agent's steps). So enforcement is three layers, and this
folder holds layer 2:

1. **Runner choke point (agnostic, in-repo):** `hooks/ftb.ps1` — phases advance only
   via `ftb next` (exit-lock + entry-lock). One rule for the agent to obey instead of
   dozens. Works on any platform with pwsh 7 + a shell tool.
2. **Platform adapters (this folder):** where a platform offers pre-tool hooks, wire
   the guard so skipping is *structurally* blocked there. Where it doesn't, layer 1 +
   layer 3 carry the weight.
3. **CI bouncer (agnostic, in-repo):** `.github/workflows/fit-to-brand-gates.yml` —
   bad run states cannot land on main, on any platform. See below.

## claude-code/ — true blocking (PreToolUse, exit 2 = blocked)

Merge `claude-code/hooks.json` into the project's `.claude/settings.json`, keeping the
`pwsh` command path correct for the machine. Every `Write`/`Edit` under
`runs/<id>/` then passes through `guard-phase.ps1`, which compares the file's earliest
phase against `STATE.json` and blocks future-phase writes with the reason + the fix
(`ftb next`). GATES/PARAMS/STATE are always writable — they are the locks, not the
work. Paths outside any initialized run are allowed silently.
Known limit (stated, not hidden): file-write hooks don't see text the agent pastes
into chat or commands run via shell heredocs — layer 3 catches those at land time.

## opencode / cursor / copilot / windsurf / other IDEs — mapping, no invented schema

Hook systems here vary by product and version (opencode exposes tool/session lifecycle
hooks through its plugin ecosystem; names and block semantics differ by install — verify
with your install's docs before relying on blocking). The portable wiring is identical
everywhere, so verify-then-wire:

| Platform capability | Wire to |
|---|---|
| Pre-write / pre-tool hook with block | `guard-phase.ps1` logic (port the phase map; block future-phase `runs/<id>/` writes, always allow GATES/PARAMS/STATE) |
| Session-start / context-injection hook | inject repo-root `SKILL.md` (router) + the run's `runs/<id>/STATE.json` contents |
| Post-write hook (no block) | `Validate-Gates.ps1 -RunDir runs/<id> -Stage <current>`; surface FAILs immediately |
| No hooks at all | layer 1 (`ftb next` one-rule) + layer 3 (CI); plus paste the router's standing orders into project instructions |

If you verify a schema on your install, contribute the adapter back in this folder's
format (guard script + install snippet + limits section).

## CI — the backstop that works everywhere (layer 3)

`.github/workflows/fit-to-brand-gates.yml` runs on push/PR: fixtures/pass must go
green, fixtures/fail must go red (both directions asserted — a validator that can't
fail is decoration), all `bridge/illustrations/data-*` must go green, `Enter-Phase`
smoke checks must behave, and any committed `runs/<id>/` snapshot (a dir containing
`PARAMS.log`) must go green. `runs/` stays git-ignored by default; opt a run into
enforcement with `git add -f runs/<id>`. A skipped gate can happen in-chat on any
platform; it cannot land on main on any platform.
