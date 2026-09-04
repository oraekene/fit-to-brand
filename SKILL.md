---
name: fit-to-brand
description: Router for the combined fit→brand→market system. Use when starting any positioning, branding, rebrand, campaign-expansion, or measurement work. Routes to icp/ (fit mapping), brand/ (visual system), or bridge/ (joint orchestrations), and enforces gate hooks before every stage transition.
---

# fit-to-brand — router

## Route first (one question)

1. **No brand exists yet** (new capability/product/mission) → `bridge/JOINT-RUN-ORCHESTRATION.md`.
2. **A live brand exists and its identity must change** → `bridge/REBRAND-ORCHESTRATION.md`.
3. **Anchor approved + Lock passing, only more assets needed** → `bridge/CAMPAIGN-EXPANSION-ORCHESTRATION.md`.
4. **Resume a run** → icp resumes by artifact (`runs/<id>/icp/` S0…S5B); brand resumes by
   checkpoint (`STATUS` → `NEXT ACTION`); measurement resumes by M-file
   (`M_PREDICTIONS.csv` → `M2_OBS.csv` → `M3_DECISIONS.md`).
5. **Solo layer work** → `icp/SKILL.md` (fit only) or `brand/SKILL.md` (craft only);
   mark bridge columns `STATUS: unaddressed` / `EVIDENCE: unvalidated` per
   `bridge/AUDIENCE-POSITIONING-BRIDGE.md` wiring rules.

## Standing orders (all routes)

- One audience list, one claims registry, one prohibited list — owned per
  `bridge/AUDIENCE-POSITIONING-BRIDGE.md`. Import verbatim; never fork.
- icp owns definition/logic; brand owns activation/expression. Words flow icp→brand;
  thread learnings flow brand→icp as findings (never silent edits to locked columns).
- Briefs ship with groups; test assets ship with audits; predictions ship with threads.
  No scale without M0 rows (`bridge/MEASUREMENT-LOOP.md`).
- **Hooks before every stage transition** — see `hooks/README.md` matrix:
  run Tier H1 validators (`hooks/Validate-Gates.ps1 -RunDir runs/<id> -Stage <stage>`);
  red blocks the next stage. H2 judge prompts for substance calls; H3 human approvals
  recorded in the run gate log (H1 verifies their existence). Prefer driving all of
  it through `hooks/ftb.ps1` (`init -RunId <id> -Variant <v> -Mode <m>` once, then
  `next` per transition): phases advance only through the runner's STATE.json —
  never self-declared. Where the platform offers pre-tool hooks, install the matching
  `hooks/platforms/` adapter; CI (`.github/workflows/`) backstops everything at land.
- **Ask before leaving every phase** — elicitation spine per orchestration, full Q-sets
  in `bridge/QUESTIONNAIRES.md` (Q0.0 run mode first: phased / batch-upfront / defaults;
  ≤3 questions per exchange, recommended first, explicit defaults; answers to
  `runs/<id>/PARAMS.log`, H1 `Test-Params` blocks on missing keys). Deterministic
  trigger: `hooks/Enter-Phase.ps1 -RunDir runs/<id> -Phase N` (-Variant Rebrand or
  Campaign where applicable) prints the phase ask-list and locks entry on missing
  prior keys. A silent run is a failed run: no phase exits on assumptions.
- New threads/groups/claims/identity changes exit to their owning run — campaign
  expansion cannot approve them; rebrand cannot skip equity guardrails.
