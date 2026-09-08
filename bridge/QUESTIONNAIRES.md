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
  Each gets the recommended answer and you approve or change it at its
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

- **Q0.1 which picture service do we use?** Pick one from the service list
  (recommended first) / do it by hand with your own tools / name the tool
  you already use. Why this matters: this choice sets the cost, the look,
  and the backup plan for every picture in the run.
- **Q0.1m which picture model do we use?** Pick the recommended model first
  (free to use while your key has no credit). Skipped if you do it by hand.
  Why this matters: the model sets the picture quality and the price.
- **Q0.2 which video service do we use?** Use the same service as for
  pictures (recommended) / pick a different service from the service list /
  still pictures only / do it by hand. Why this matters: this choice sets
  the cost, the look, and the backup plan for every video in the run.
- **Q0.2m which video model do we use?** Pick the recommended model first
  (free to use while your key has no credit). Skipped unless you pick a
  different video service. Why this matters: the model sets the video
  quality and the price.
- **Q0.3 which tool finishes the layout?** Pick Figma (recommended) /
  Illustrator / Canva / make it with code / idea only with no finished
  file. Why this matters: the tool that finishes the layout fixes the text
  faults in every finished file.
- **Q0.4 which font source do we use?** Pick Google Fonts (recommended) /
  Adobe Fonts (show the license) / a paid font seller (name it) / the fonts
  on your device. Why this matters: this choice sets where the fonts come
  from and proves that we have permission to use them.
- **Q0.5 what spending cap do we use?** Pick a unit (credits / tokens /
  API-$ / render-minutes / seat-time) and give a number. There is no
  default. Skipped if you picked a preset. Why this matters: every work
  plan prices against this cap.

- **Q0.6 what shape is your subject?** Pick digital (software or an app) /
  physical (a device or kit) / hybrid (a device with software) /
  human-service (setup, care, or teaching). There is no default. Why this
  matters: this choice sets which sources I request and which words
  describe it.
- **Q0.7 do you accept the 5-item pack of sources?** I show you the 5
  items for your shape. Accept the pack (recommended) / swap one source /
  send all sources. Why this matters: I can only cite what you give me, so
  a thin pack leaves gaps later. If your mail or chat has the sources,
  send them by hand.
  Packs by form × run-mode (show only the matching pack, never all 280):
  digital-single: repo/README + docs/wiki + site+pricing + 1 user-voice (tickets OR
  Slack/Teams/Discord OR Gong/calls) + claims/certs if any; physical-single:
  BOM/datasheet + manual/warranty + catalog/price sheet + 1 field-voice (reviews OR
  RMAs) + cert regime if any; human-service-single: SOP/menu/rate card + 1
  contract/SOW + 1 voice (tickets/calls/reviews) + staffing/training iff delivery
  gap; hybrid: digital pack + BOM/manual; category: 3–5 competitor feature+pricing
  pages + 1 comparison matrix + 1 review source (G2 OR Amazon OR App Store) +
  analyst/teardown iff wedge disputed; company/org as subject: charter/deck + org
  chart + 1 financial + 1 binding constraint.
  Agent note: take personal files by hand first and list them below. Never
  wait for a live link.
- **Q0.8 which legal constraints apply to us?** Pick none-known (recommended) /
  a binding rule (name it: UL, CE, FDA, DOT, ROE, LOAC, curriculum, or
  customary) / a regulated promise (name it). TBD is a legal answer and
  stays flagged. Why this matters: what you name here stays out of scope
  and off the no-go list. If safety is at stake and nothing is named, the
  run stops here.
  What the names mean: UL = US product safety tests. CE = EU market mark.
  FDA = US food, drug, and device clearance. DOT = US transport safety
  rules. ROE = rules on when to use force. LOAC
  = law of armed conflict. Curriculum = the official learning standard
  where you teach. Customary = local custom and elder approval. Name the
  one that binds you, or name another.

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

- **Q1.1 what is the scope?** Pick single (one product, recommended for a
  product launch) / category (whole category). Why this matters: the scope
  decides whether we can make challenger promises later.
- **Q1.2 which market setup do we use?** Pick O-GTM (sell products, recommended)
  / O-OPS (field operations) / O-EDU (learning) / O-SUBSISTENCE (trade without
  money) / custom (you define it later). Why this matters: the setup sets the
  words for groups, channels, and rules. Mixed terms fail the checks.
- **Q1.3 do you accept the size limits 300/50/10?** Accept them (recommended) /
  tighten them / loosen them (give numbers). The three numbers cap the write-up,
  the ranking, and the shortlist. Why this matters: the limits cap the length
  of each result.
- **Q1.4 which promises can we make?** Give the promises we can make, the
  forbidden promises, and the certificates you hold. For example: 'charges
  three phones a day' is a promise we can make, and 'cools the room' is
  forbidden. A certificate proves a regulated promise, like a CE mark behind
  'meets EU safety rules'. TBD is a legal answer and stays flagged. Why this
  matters: this builds the promise list and the out-of-scope list.

## Q2 — S1 fork (only on Epistemic Fork ties; otherwise keep both silently)

- **Q2.1 which theme reads truer?** I show you both themes. The broad one
  covers more situations. The sharp one names the winning difference. Keep
  both (recommended) / commit to the broad one / commit to the sharp one.
  I ask this only when both read equally true. Otherwise I keep both
  without asking. Why this matters: one theme focuses later work, and both
  cost double.

## Q3 — S2/S3 + reference selection (before leaving S3)

- **Q3.1 which currency and year do we use?** Pick USD and the current year
  (recommended) / another currency and year (name them) / staple amounts (for
  trade without money). Why this matters: one currency keeps all prices
  comparable.
- **Q3.2 do you need a market slice of your own?** A market slice is one
  industry or trade. The built-in slices are SEC-HEALTH, SEC-MINING,
  SEC-MARITIME, SEC-AGRI, SEC-ENERGY, SEC-BUILT, SEC-INFORMAL, and
  SEC-REGULATED (health, mining, sea trade, farming, energy, building,
  informal trade, regulated work). No (recommended) / yes, name it
  (starting with SEC-) and define it in one line. Why this matters: a named
  slice marks your industry in every result.
- **Q3.3 which visual reference do we use?** I show you one reference that
  works across scenes. Approve my pick (recommended if you agree) / send
  another image / describe the direction in words. Why this matters: the
  reference must work in every scene, not just look good.

## Q4 — S4/S5A (before leaving S5A; category-mode only for Q4.1)

- **Q4.1 rank the top two winning differences:** price / performance /
  distribution / compatibility. Asked only in whole-category runs. Why this
  matters: the ranking orders the shortlist.
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
