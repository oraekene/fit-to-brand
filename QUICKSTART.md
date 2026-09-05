# QUICKSTART — the one-click run (3 interactions)

```powershell
# 1. One command: scaffold + provider preset + subject form + all safe defaults
./hooks/ftb.ps1 quickstart -RunId acme-001 -Variant Joint -Preset lovart -Form digital -Subject "200W PAYG solar kit"

# 2. First interrupt: tick the SOURCES.log pack checklist (drop 1-5 sources) — S0 can't close without it
# 3. Do each phase's work; auto-advance (re-run whenever it stops)
./hooks/ftb.ps1 run -RunId acme-001

# 4. One batched approval screen when asked (Gates 1-4 + Anchor + pending plans, single confirm)
```

Presets (`bridge/PROFILES.md`): `lovart` / `gpt` / `api` / `midjourney` /
`firefly` / `local` / `figma` / `docs`. Registry alternative
(`bridge/PROVIDERS.md`): swap `-Preset <name>` for `-Provider <id> [-Model
<m>]` — Q0.3–Q0.5 are then asked live at phase 0. Manual setup is still available:
`init -RunId <id> -Variant <v> -Mode <m> [-Preset <name>]`, then `next` per phase.

## What quickstart seeds (and what it deliberately doesn't)

Seeded with `src=asked` (you chose them on the command line): Q0.0 mode=defaults,
Q0.1–Q0.5 from the preset, Q0.6 from `-Form digital|physical|hybrid|human-service`
(form has no default per Q0.6 — the flag is the 1 click); plus `runs/<id>/PROFILE.md`
and a `SOURCES.log` template with your form's pack checklist.
Seeded with `src=default` (doc defaults, challenge any at phase): Q1.1 single,
Q1.2 O-GTM, Q1.3 300/50/10, Q1.4 TBD, QN.0 working title from `-Subject`,
Q0.7 accept-pack, Q0.8 none-known, Q3.1 USD+year, Q4.2/Q4.3 none-known, Q10.1 minimum module set, Q13.1 motion
thresholds, QRP.1 standard report (plus QC.1 proven-first on Campaign runs).
NOT seeded — confirmed at phase with a short confirm, then `run` again: Q3.3,
Q5.1, Q5.2, Q6.1, Q7.1, Q8.1, Q8.2 (every generation), Q9.1–Q9.3, Q11.1–Q11.3,
Q12.1, Q12.2, Q14.1.
NEVER defaulted — always asked live: Q14.2 kill/launch-hold confirms, QN.4
trademark/domain/handle checks, QR.1 equity sort (rebrands).

## The approval batch (one screen, not a dozen pings)

When the run reaches its gates, approve once with everything visible — each Gate
1–4 + Anchor + pending Generation Plans with diffs and the recommended action —
then record in one go (`H3 Gate<N> APPROVED <date> <who>` lines in `GATES.log`,
one line per gate). Wizard rule holds: Anchor, launch-hold, and group-kill are
explicit confirms, never bulk-accepted sight unseen.

## Changing one answer (override)

Append a `PARAMS.log` line (later lines win for entry locks), update PROFILE.md
if it's provider-related, re-issue pending Generation Plans:

```powershell
Add-Content runs/acme-001/PARAMS.log -Value "Q0.2 = Runway | 2026-09-04 | adaeze | src=asked"
```

## Mini-transcript

```text
> ./hooks/ftb.ps1 quickstart -RunId acme-001 -Variant Joint -Preset docs -Form digital -Subject "PAYG solar kit"
INIT: run acme-001 (Joint, defaults, preset docs, form digital) opened at phase 0
SEEDED: Q0.0-Q0.5 (preset, src=asked) + Q0.6 form (flag, src=asked) + Q0.7, Q0.8, Q1.1-Q1.4, QN.0, Q3.1, Q4.2, Q4.3, Q10.1, Q13.1, QRP.1 (doc defaults, src=default)
FIRST INTERRUPT: tick the SOURCES.log pack checklist (append S<nn> lines) ...
> ./hooks/ftb.ps1 run -RunId acme-001
ADVANCED: run acme-001 now in phase 1
ASK NOW (phase 1 Q-set — <=3 per exchange, recommended first):
...
```

Full Q-set wording: `bridge/QUESTIONNAIRES.md`. Gate matrix: `hooks/README.md`.
