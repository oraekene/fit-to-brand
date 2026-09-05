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

## Q0.0 — How you answer questions (the very first question, before Q0.1)

- **Q0.0 how do you want to answer questions?** (a) Step by step — I ask
  at each step (recommended for first runs) / (b) Upfront — you answer two
  rounds now, then I stay quiet / (c) Defaults — I use the recommended
  answers and stop only where you must choose.

## Modes (set by Q0.0)

- **step by step (the default):** I ask each step's questions when we reach
  that step. Most interruptions, most context per question.
- **upfront:** two rounds now, then quiet. **Round 1** (needs nothing
  answered first): picture and video tools, layout tool, fonts, spending
  cap, subject shape, source set, legal constraints, scope (one product or
  a whole category), size limits, promise list, currency, certificate
  rules, guideline chapters (plus which old assets to keep, for rebrands,
  or which messages to launch first, for campaigns). **Round 2** (builds
  on Round 1): picture model (only if Round 1 picked a picture service),
  video model (only if Round 1 picked a different video service), sales
  channel setup (only if you picked custom), market slices, your winning
  difference (only for whole-category runs), stop rules (I propose per
  group, you approve at launch). **The rest** (needs run results to exist,
  so no honest upfront answer is possible): theme tie-break, reference
  pick, grouping and buying checks, import and direction approvals, font
  and work-plan approvals, review and locked-design approvals,
  product-version and final checks, packaging and signoff, result reviews.
  Each gets the recommended answer now and you approve or change it at its
  step. I never pre-answer stop decisions or launch holds. I always ask
  those live.
- **defaults:** every question with a recommended answer takes it. I still
  ask live where no recommended answer exists: your spending cap, your
  subject's shape (one click, no default), which old assets to keep
  (rebrands only, your judgment, no default), approval to stop a group or
  hold a launch. The source set defaults to accept, legal constraints to
  none known, the promise list is left to decide, forbidden claims to none
  known, campaign messages to proven-first. I mark each default choice,
  and you make sure that it is right at its step.

## Q0 — Setup (before S0; three exchanges: Q0.1–0.3, then Q0.4–0.5, then Q0.6–0.8)

- **Q0.1 image provider?** Registry id from `bridge/PROVIDERS.md` whose
  `images` ≠ `none` (Recommended: registry default) / `manual` (keep the
  preset/web-manual path via `PROFILES.md`) / legacy toolchain prose
  (accepted, pre-registry runs stay green). *Why: fixes cost, quality, and
  fallback behavior for the whole run — now as a select, not an essay.*
  → Provider Profile image line + `Q0.1 = <id|manual|prose>`.
- **Q0.1m image model?** The row's static default models (recommended first;
  free-tier-safe default while the key carries no credit — see
  `PROVIDERS-SPEC.md` §5). Skipped iff Q0.1 is `manual`. → model select
  recorded beside the provider.
- **Q0.2 video/motion provider?** Same-stack-as-Q0.1 (Recommended: motion
  follows the image provider+model) / registry id whose `video` ≠ `none` /
  None → storyboard fallback / `manual`. Default: same-stack. → profile.
  **Q0.2m video model?** Asked iff Q0.2 names a registry id other than the
  Q0.1 row (row static default recommended first).
- **Q0.3 layout/export finisher?** Figma (Recommended) / Illustrator / Canva /
  code-SVG / None-conceptual-only. *Why: whoever finishes type owns text defects.*
  Default: Figma. → profile.
- **Q0.4 font source?** Google Fonts (Recommended default) / Adobe Fonts (license
  confirmed?) / commercial foundry (which?) / system stack. → Approved Font Source.
- **Q0.5 cost unit + cap?** credits / tokens / API-$ / render-minutes / seat-time +
  a number. *Why: every Generation Plan prices against this.* No doc default —
  presets in `bridge/PROFILES.md` carry default caps (`quickstart -Preset` seeds
  yours with `src=asked`); manual runs must answer.

- **Q0.6 subject form?** digital = software/app/SaaS, `(a)` is a code swap
  (Recommended if repo/docs/site exist) / physical = device/tool/appliance/kit,
  `(a)` is a full-SKU swap / hybrid = device+software, both lenses / human-service
  = install/maintenance/coaching/mediation, `(a)` is a service swap. *Why: picks the
  5-item context pack and fixes which S4 verbs are legal (software-only `b-ING/
  b-FACE/b-SRC` never attach to pure-physical).* No default — 1 click. → S0 header
  `form:` + `SOURCES.log` pack selector.
- **Q0.7 context pack — accept the 5-item pack?** Accept pack (Recommended) / swap
  one source / batch-upload all now. *Why: S0 can only cite what it was given — a
  thin spec propagates as missing `spec_link` (S2) and missing `spec cite` (S5A).*
  Packs by form × run-mode (show only the matching pack, never all 280):
  digital-single: repo/README + docs/wiki + site+pricing + 1 user-voice (tickets OR
  Slack/Teams/Discord OR Gong/calls) + claims/certs if any; physical-single:
  BOM/datasheet + manual/warranty + catalog/price sheet + 1 field-voice (reviews OR
  RMAs) + cert regime if any; human-service-single: SOP/menu/rate card + 1
  contract/SOW + 1 voice (tickets/calls/reviews) + staffing/training iff delivery
  gap; hybrid: digital pack + BOM/manual; category: 3–5 competitor feature+pricing
  pages + 1 comparison matrix + 1 review source (G2 OR Amazon OR App Store) +
  analyst/teardown iff wedge disputed; company/org as subject: charter/deck + org
  chart + 1 financial + 1 binding constraint. Personal data (Gmail/Slack/notes/chat
  histories): manual export drop to Inbox first, live connector later — never block
  S0 on OAuth. → `runs/<id>/SOURCES.log` manifest (schema below); `spec-sha`
  resolves to it.
- **Q0.8 anything binding?** none-known (Recommended default) / cert-regime [name
  it: UL/CE/FDA/DOT, ROE/LOAC, curriculum, customary] / regulated-claim [name it].
  `TBD` legal, stays flagged. *Why: seeds Out-of-Scope + NOT-fit before the agent
  writes them; safety-critical fit without a named regime is red.* → S0
  Out-of-Scope + NOTFIT.md seed.

**SOURCES.log format** (one line per source, H1-readable):
`S<nn> = <label> | <family F1-F6> | <path-or-url> | <sha256-or-n/a> | <yyyy-mm-dd> | <who> | src=<asked|dropped|batch|default>` —
e.g. `S01 = repo-tree | F1 | github.com/org/repo@a1b2c3 | sha:a1b2c3 | 2026-09-04 | adaeze | src=dropped`.
Families: F1 what-it-is (code/technical), F2 what-you-promise (site/marketing),
F3 what-you-agreed (docs/commercial/operational), F4 what-users-say
(SaaS/comms/personal), F5 what-binds-you (org/legal/financial), F6 category-market.
H1 reads only the `S<nn> =` head, so provenance never breaks hooks. Minimum 1 line;
recommended 5 (the accepted pack). `spec-sha` in the S0 header MUST match the
manifest hash or the short-hash of the manifest file — dangling `spec-sha` is red.

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
  matches) / request changes / cancel. *Fires before every costly generation.
  When the plan cites `provider:` + `model:`, approval cites the green
  `Test-Provider` check (eligibility); the spend decision stays human.*

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

## QN — Naming (pipeline: `bridge/NAMING.md`; S0 declares `naming: required|n/a`)

- **QN.0 working title?** Keep the S0 project name as PROVISIONAL (Recommended) /
  propose another. → S0 handle; nothing downstream treats it as decided.
- **QN.1 rank the criteria?** Order tier-signal vs distinctiveness vs descriptiveness
  (top two suffice). *Why: breaks shortlist ties deterministically.* → applied at N4.
- **QN.3 pick from the screened shortlist?** Choose one (screens + tier-read + QN.1
  rank shown) / send back for more candidates. *Required at phase-6 entry when naming
  is required — a kit built on an unlocked name is rework.* → NAMES.csv pick.
- **QN.4 manual checks done?** Confirm trademark search + domain + handle (each `ok`
  or `waived: reason`). *The agent cannot do these — human confirms, no default,
  no bulk approval.* → NAMES.csv manual columns.

## QN-R — Rename verdict (rebrand only, alongside QR)

- **QN-R.1 name: keep / evolve / replace?** Decide with name-equity priced
  (recognition, contracts, shelf, search). Replace routes into N1–N5 with OLD in the
  confusion corpus; keep routes to migration-copy only.

## QRP — Reports (catalog + pipeline: `bridge/REPORTS.md`)

- **QRP.1 report brief?** Audience + depth (skim = decisions + numbers only /
  standard (Recommended) / deep) + language. Asked at M0/Stage 11 for R-FINAL and per
  trigger for the rest. *Why: a report without a reader is a data dump.* → report
  header + journey mode emphasis.
