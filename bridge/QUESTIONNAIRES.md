# Elicitation system — phase-gated user questionnaires (ASK spine)

**Why this exists:** the skills say "ask the user," but no gate ever checked that
asking happened — headers filled themselves with defaults and runs sailed through
silent. Every Q-set below is bound to the phase that needs it: the agent fires these
via the question tool (≤3 per exchange, recommended option first, explicit default),
records answers in `runs/<id>/PARAMS.log`, writes through to the owning artifact, and
the H1 `Test-Params` hook blocks the transition when required keys are missing
(see `hooks/README.md`). A missing answer is a red gate, not an assumption.

**Borrowed mechanics (not whole skills):** from `wizard`, confirm-before-irreversible
(Anchor, launch-hold, group-kill); from `to-questionnaire`, one idea per question plus
a *why-it-matters* line and an explicit default — but asked live by the agent, never
as an async third-party doc.

**Rules:** ask at the last responsible moment (never an upfront mega-form — unless the
user picks batch mode below); ≤3 questions per exchange in phased mode; every question
offers options with a recommendation and a default; `TBD` is a legal answer only where
marked (and stays flagged until filled); re-ask only when `GO BACK` invalidates the
answer.

**PARAMS.log format** (one line per answer, H1-readable):
`Q<id> = <value> | <yyyy-mm-dd> | <who> | src=<asked|batch|batch-deferred|default>` —
e.g. `Q1.1 = single | 2026-09-04 | adaeze | src=asked`. `src` is provenance: later
audits must distinguish answered from defaulted. Validator regexes read only the
`Q<id> =` head, so provenance never breaks hooks.
Write-through targets are listed per Q-set.

## Q0.0 — Run mode (the very first question, before Q0.1)

- **Q0.0 how do you want to answer questions?** phased = ask at each phase
  (Recommended for first runs) / batch-upfront = answer everything answerable now in
  frontier rounds R1–R2 (see Modes), rest deferred with defaults / defaults = take
  every recommended default, interrupt only where no default exists. → run mode,
  recorded first in PARAMS.log; `Enter-Phase.ps1` and `Test-Params` compose with all
  three (keys are keys regardless of `src`).

## Modes (set by Q0.0; frontier model borrowed from batch-grill-me)

- **phased (default):** Q-sets fire at their phase per the elicitation spine tables.
  Maximum context per question, maximum interruptions.
- **batch-upfront:** two rounds now, then quiet. **R1** (no prerequisites): Q0.1–Q0.5,
  Q1.1, Q1.3, Q1.4, Q3.1, Q4.2, Q4.3, Q10.1, QR.1 (rebrands), QC.1 (campaigns).
  **R2** (depends on R1): Q1.2 custom-overlay definition (iff custom), Q3.2 sectors,
  Q4.1 wedge rank (iff category), Q13.1 thresholds (proposed per motion, confirmed at
  M0). **Deferred-with-defaults** (depend on run artifacts, cannot be answered
  honestly upfront): Q2.1, Q3.3, Q5.1, Q5.2, Q6.1, Q7.1, Q8.1, Q8.2, Q9.1–Q9.3,
  Q11.1–Q11.3, Q12.1, Q12.2, Q14.1 — recorded `src=batch-deferred`, each confirmed or
  challenged at its phase (a short confirm, not a re-ask). Q14.2 is never
  deferred-defaulted: kills are always asked live.
- **defaults:** every Q with a stated default auto-records `src=default`. Still asked
  live (no default exists): Q0.5 (budget cap), QR.1 (equity sort — judgment, no
  default), Q14.2 (kill/launch-hold confirms). Q1.4 defaults to `TBD`, Q4.3 to
  `none-known`, QC.1 to its pre-checks — flagged or confirmed at phase as usual.

## Q0 — Setup (before S0; two exchanges: Q0.1–0.3, then Q0.4–0.5)

- **Q0.1 image generator?** Options: Lovart-native (Recommended if running in Lovart) /
  GPT-image-class / Midjourney + LLM direction / Adobe Firefly / local SD-Comfy /
  Other. *Why: fixes cost, quality, and fallback behavior for the whole run.*
  Default: Lovart-native. → Provider Profile image line.
- **Q0.2 video/motion generator?** Same-stack-as-image (Recommended) / Runway /
  Pika-Kling-Sora-Luma / None → storyboard fallback. Default: same-stack. → profile.
- **Q0.3 layout/export finisher?** Figma (Recommended) / Illustrator / Canva /
  code-SVG / None-conceptual-only. *Why: whoever finishes type owns text defects.*
  Default: Figma. → profile.
- **Q0.4 font source?** Google Fonts (Recommended default) / Adobe Fonts (license
  confirmed?) / commercial foundry (which?) / system stack. → Approved Font Source.
- **Q0.5 cost unit + cap?** credits / tokens / API-$ / render-minutes / seat-time +
  a number. *Why: every Generation Plan prices against this.* No default — must answer.

## Q1 — S0 freeze (before leaving S0)

- **Q1.1 run-mode?** single = one offering, `(a)` means full swap (Recommended for a
  product launch) / category = whole category, `(a)` means share-shift with a wedge.
  *Why: licenses or forbids challenger claims downstream.* → S0 header.
- **Q1.2 overlay?** O-GTM (Recommended default) / O-OPS / O-EDU / O-SUBSISTENCE /
  custom (then define channel enum + cert regime + group noun + brief format). → header.
- **Q1.3 quotas — accept 300/50/10?** Yes (Recommended) / tighten / loosen (give
  numbers). → header quotas.
- **Q1.4 claims seed?** Approved claims / prohibited claims / certs-regimes you already
  know (provide, or `TBD` — legal answers, flagged until filled). *Why: seeds the one
  claims registry; S0 Out-of-Scope is built from this.* → S0 + claims registry.

## Q2 — S1 fork (only on Epistemic Fork ties; otherwise keep both silently)

- **Q2.1 which theme reads truer — broad or sharp?** Keep-both (Recommended default) /
  commit broad / commit sharp. → fork tag on all downstream runs.

## Q3 — S2/S3 + reference selection (before leaving S3)

- **Q3.1 currency/year/PPP?** USD + current year (Recommended) / other base / staple-
  equivalents (subsistence runs). → S3 header.
- **Q3.2 custom sectors?** None (Recommended) / add `SEC-` keys with one-line
  definitions. → S2 header.
- **Q3.3 reference: approve the stretch-tested pick, supply another, or brief one?**
  Approve pick (Recommended if stretch note holds) / supply image / describe direction.
  *Why: the reference must survive Top-K scenes, not just please.* → Stage 1 input.

## Q4 — S4/S5A (before leaving S5A; category-mode only for Q4.1)

- **Q4.1 wedge priority?** price / performance / distribution / compatibility (rank top
  two). → K-fit wedge ranking.
- **Q4.2 which cert regimes touch us?** UL-CE-FDA-DOT set / ROE-LOAC / curriculum /
  customary / none-known (`TBD` legal). → overclaim guardrail + safety notes.
- **Q4.3 what must we never claim?** Free text, or `none-known`. *Why: seeds NOT-fit
  before the agent writes it.* → NOTFIT.md seed.

## Q5 — S5B regroup (before leaving S5B)

- **Q5.1 grouping check: any buyer missing, merged, or split?** Accept groups
  (Recommended) / add / merge / split (name them). *Why: cheapest moment to fix the
  audience — later it costs a `GO BACK`.* → S5B_GROUPS.csv.
- **Q5.2 motion per group — PLG vs enterprise (or overlay equivalent)?** Accept
  proposed (Recommended) / correct per group. → group rows; sets CTA hardness + M
  cadence later.

## Q6 — Brand Stage 0 (brief Q1–Q10, conversational per skill; plus one import check)

- **Q6.1 import S5B table + Block B + S0 claims verbatim?** Yes (Recommended) / adjust
  (what exactly — adjustments return as S5B findings, never silent forks). → brief.

## Q7 — Stage 1 → Gate 2

- **Q7.1 approve transferable principles + prohibitions + direction statement?**
  Approve (Recommended) / adjust named item / reject (→ new direction, not a blend).

## Q8 — Stage 2 (fonts first, then every generation)

- **Q8.1 font system A or B?** A (Recommended, agent states why) / B / neither (state
  what to change). → typography approval; kit cannot generate before this.
- **Q8.2 Generation Plan: approve, change, or cancel?** Approve (Recommended if plan
  matches) / request changes / cancel. *Fires before every costly generation.*

## Q9 — Stage 3 → Gate 3

- **Q9.1 agree KEEP / REMOVE / REFINE?** Accept (Recommended) / contest named items.
- **Q9.2 REFINE vs RESTART recommendation — accept?** Accept (Recommended with trigger
  list shown) / override (state which triggers you read differently).
- **Q9.3 Anchor approval?** Approve as source of truth (Recommended) / refine named
  rule / reject direction. *Irreversible-adjacent → wizard-style explicit confirm;
  rebrand adds deprecation scope to this confirm.*

## Q10 — Stage 4

- **Q10.1 which guideline modules?** Multi-select, minimum set pre-checked
  (Recommended). → one 16:9 slide each.

## Q11 — Stages 5/6/9 (three small gates)

- **Q11.1 SKU list confirmed?** Accept / amend. → Stage 5 validation set.
- **Q11.2 Brand Lock roles confirmed?** Confirm (Recommended) / correct a role. Gate 4;
  one test asset follows, never scale before audit.
- **Q11.3 formats + approved variables for scale?** Accept matrix / amend. → Stage 9.

## Q12 — Stages 10/11

- **Q12.1 requested packaging views?** Accept suggested six / amend.
- **Q12.2 final review signoff?** Sign (Recommended when checklist passes) / hold named
  item. → completion report + M0.

## Q13 — M0 predictions (before any flight; defaults proposed per motion)

- **Q13.1 kill + reposition thresholds per thread — accept proposed?** Accept defaults
  (Recommended; e.g. PLG: rate floor after 1k impressions; enterprise: after one
  pipeline review) / adjust per thread. *Why: a prediction without a kill line is
  logging, not measurement.* → M_PREDICTIONS.csv. Confusion trip default 10%.

## Q14 — M3 judging (per flight)

- **Q14.1 verdicts accept or override?** Accept table (Recommended) / override named
  PRED-ID with reason. → M3_DECISIONS.md.
- **Q14.2 KILL-GROUP and launch-hold confirms?** Explicit confirm required, always —
  no default, no bulk approval (wizard-style irreversible confirm). → retirement notes.

## QR — Rebrand extras (in addition to the joint spine)

- **QR.1 equity guardrails?** For each recognition asset: must-keep / negotiable /
  must-drop (user sorts; conflicts with audit escalate, never auto-resolve).
- **QR.2 per-group keep / kill / merge / split?** Accept proposed regroup
  (Recommended) / change named groups. → S5B regroup rows.
- **QR.3 coexistence window?** 8 weeks (Recommended default) / other sell-through
  timing. → transition plan.

## QC — Campaign extras (in addition to the joint spine)

- **QC.1 which threads fly?** Multi-select from the candidate scene×SKU×format matrix
  (proven first is pre-checked). → THREADS.csv STATUS.
- **QC.2 new scene family ack?** Confirm test-asset-before-scale understood (always
  asked — this is where drift enters). → Gate 4 per family.
