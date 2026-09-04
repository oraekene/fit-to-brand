# Orchestration 1 — Recommended Joint Run (new capability → new brand → market)

Full combined sequence: icp-6 S0→S5B, then brand Stages 0→11, then M0→M4.
Companion contracts: `AUDIENCE-POSITIONING-BRIDGE.md` (Blocks A+B), `MEASUREMENT-LOOP.md` (M0–M4).
Variants: existing brand → `REBRAND-ORCHESTRATION.md`; assets only, system exists → `CAMPAIGN-EXPANSION-ORCHESTRATION.md`.

Rule for the whole run: **icp-6 owns definition and logic; brand owns activation and
expression; the bridge owns the join.** Never maintain two audience lists, two claim
lists, or two prohibited lists. Copy verbatim, never fork.

## Elicitation spine (ASK before leaving each phase — full Q-sets in `QUESTIONNAIRES.md`)

No phase is left without its questions; a missing answer blocks like a red gate
(H1 `Test-Params` checks `PARAMS.log`). Fire via the question tool, ≤3 per exchange,
recommended option first. Deterministic runner: `hooks/Enter-Phase.ps1 -RunDir
runs/<id> -Phase N` asserts entry keys and prints the exact ask-list (exit 1 =
BLOCKED with the missing questions named):

| Phase | ASK | Blocks exit until |
|---|---|---|
| 0 Setup | Q0.0 (mode first) + Q0.1–Q0.5 (image / video / layout / fonts / cost+cap) | Provider Profile complete |
| 1 S0→S1 | Q1.1–Q1.4 (run-mode / overlay / quotas / claims seed); Q2.1 only on fork ties | header stamped from answers, not defaults |
| 2 S2→S3 | Q3.1–Q3.3 (currency / sectors / reference pick) | stretch-tested reference chosen |
| 3 S4→S5A | Q4.1–Q4.3 (wedge rank / cert regimes / never-claims) | NOT-fit seeded by user, not just agent |
| 4 S5B | Q5.1–Q5.2 (grouping check / motion) | groups confirmed before briefs lock |
| 5 brand 0→1 | Q6.1 (import ack); Q7.1 (Gate 2 direction) | brief imported, direction approved |
| 6 brand 2→3 | Q8.1 (fonts A/B); Q9.1–Q9.3 (audit agree / refine-vs-restart / Anchor confirm) | Anchor confirmed explicitly |
| 7 brand 4→5 | Q10.1 (modules); Q11.1 (SKUs) | modules + SKU set locked |
| 8 brand 6→9 | Q8.2 every generation; Q11.2 (Lock roles); Q11.3 (formats+variables) | plan approved, roles confirmed |
| 9 brand 10→11 | Q12.1 (views); Q12.2 (signoff); Q13.1 (kill/reposition thresholds) | M0 rows exist per scaled thread |
| 10 M1→M4 | Q14.1 (verdicts); Q14.2 (kill-group / launch-hold confirms — no defaults) | kills explicitly confirmed |

## Run map

```text
SETUP (folders, Provider Profile, naming)
→ S0 spec freeze → S1 theme fork
→ S2 situations → S3 stakes → [reference selection]
→ S4 incumbents → S5A fit → S5B groups+briefs → [Blocks A+B]
→ brand Stage 0 (import) → Gate 1
→ Stage 1 deconstruction → Gate 2
→ Stage 2 first kit → Stage 3 review → Gate 3 (Anchor)
→ Stage 4 guidelines → Stage 5 key visual (thread matrix)
→ Stage 6 Brand Lock → Gate 4 → Stage 7 audit → Stage 8 correction → Stage 9 scale
→ Stage 10 packaging → Stage 11 final review + M0
→ M1 instrument → M2 collect → M3 judge → M4 feed back → re-gate → re-render
```

## Phase 0 — Setup

**Do:**
1. Create run folders: `<run>/icp/` (S0–S5B artifacts), `<run>/brand/` (brief → deliverables),
   `<run>/bridge/` (Blocks A+B tables, M-files). One run ID everywhere.
2. Declare the brand **Provider Profile** now (image / video-motion / layout-export /
   font source / cost unit / capability flags + fallbacks). icp-6 needs no provider, but
   log `model|temp|date` in every S-artifact header ( honesty/provenance gate).
3. Fix naming: `S-0001`, `P-0001`, `GRP-ID`, `PRED-ID`, `<run>-M*.csv`. Name chaos is a
   gate fail (failure mode X-2).

**Gate:** run ID + Provider Profile + naming recorded before S0.

## Phase 1 — S0 spec freeze → S1 theme fork

**Inputs:** codebase / docs / site copy / marketing artifacts (or category sources in
category-mode). Dumps go to `Appendix_Raw.md` with SHA manifest — never merged verbatim
into the normative spec (failure S0-1).
**Do (S0):** write `S0_SPEC.md` — Problem / Solution / numbered User Stories /
Implementation / Testing with one runnable acceptance test / **Out-of-Scope (required,
empty = fail)** / Notes. Header stamps `project | run-mode single|category | overlay
(default O-GTM) | platform-role (only if the subject sits in a platform — omit for
soap/tractors/haircuts) | line-cap/K-rank/K-fit | model | temp | date | spec-sha`
(`icp/references/S0_spec.md`).
- Run-mode decides positioning ambition downstream: `single` → `(a)` = full swap;
  `category` → `(a)` = share-shift with stated wedge, self-match never `(a)`.
- Seed the joint claims registry here: approved/prohibited claims, certs, dims,
  regulatory copy. Brand's `Never Invent` list will import it — one list, owned by S0.
**Do (S1):** RTD L0→L6 worksheet + battery (Distinctiveness / Reconstruction 80%+ /
Portability / Collapse / Minimality) + keep **both** `theme_broad` and `theme_sharp`
(≤3 words, grammar-checked); record the fork. Tag every downstream step with which
theme it uses (toggle T5; failure S1-3).
**Brand implication (no brand generation yet):** `theme_sharp` will become the
creative-direction constraint; run-mode sets challenger-swap vs ingredient-wedge
positioning. Record both in the setup notes.

**Gate:** Out-of-Scope present, run-mode + overlay declared, body within line-cap,
header stamped; worksheet + battery saved, theme grammatical, fork recorded.

## Phase 2 — S2 situations → S3 stakes → reference selection

**Do (S2):** enumerate on the fixed A1-A14 + B1-B13 skeleton, one row per S-ID with
`knowledge_need | decision_moment | action_moment` (any one lens may be `N/A: reason`,
≥1 substantive) + `spec_link` + valid `sector_tags` (or empty). Emit
`S2_SITUATIONS.csv` + bulleted `S2_SITUATIONS.md` (one bullet per S-ID, no
comma-paragraphs). One file only (failure S2-3).
**Do (S3):** score every S-ID on **both** lenses — `direct_ticket` (decision value,
pricing/GTM) + `failure_cost` (max single-event/annualized × irreversibility,
litigation 2–10x, regulatory, life-safety, tail, bleed, compounding) — with base
currency/year/PPP source, both tier columns (decade + narrative + livelihood), `$0`
only with `priceless_flag` or `no_direct_ticket` + reason, sourced anchors. Derive
views (decade rank, amplifier, forced Top-K, livelihood re-score) — never re-run for
a view (toggles T1/T2).
**Do (reference selection — joint step):** pick the brand's **one main visual
reference** against the Top-K S-IDs, not taste alone: the reference must plausibly
stretch across the Top-K scenes (composition/lighting/material families that survive
sector_tags, e.g. SEC-REGULATED vs SEC-INFORMAL realities). Record why it stretches
in one paragraph; this becomes Stage 1 input.

**Gate:** header N = S2 rows = S3 rows; every row has spec_link + ≥1 substantive lens;
currency/year/PPP stated; every $0 flagged; reference-stretch note written.

## Phase 3 — S4 incumbents → S5A fit

**Do (S4):** for every S-ID list products + services + categories **USED FOR**
performing it (4b wording — never pure-product 4a inventory). Schema: `P-ID |
category | type | form (required) | examples | tier_span | domain | S-IDs_covered |
unit_economics | channel (overlay enum) | warranty_reg` — physical rows require the
last three; channel/certs outside the overlay registry = fail. Add coverage ratios,
white-space, graveyard, structural findings, own-stack-as-positions. **Zero `(a)/(b)`
tags here** (failure S4-5).
**Do (S5A):** disposition every (S-ID, P-ID) with verb (`(a)` / `b-ING/b-FACE/b-SRC/
b-COMP/b-SURV` digital, `b-ACC/b-DIST/b-SERV` physical, `X` + reason) + `landing_place`
(one sentence in overlay terms: file path / BOM / kit / shelf / work order / node /
classroom / LMS) + `spec_module_cite` (§x.y). Honor run-mode; software-only verbs
never on pure-physical; regulated/safety-critical ships `X` or narrow `b-` + safety
note naming the cert regime. Record NOT-fit (non-empty or justified), K-fit insertion
points, K-fit replacements/wedges. Single pass only.
**Joint outputs:** must-not-resemble set (P-IDs for brand's prohibited list), K-fit
Top-10 (differentiation backbone), NOT-fit (prohibited-styles seed).

**Gate:** every S-ID ≥1 P-ID; all four catalog sections exist; zero fit tags in S4;
every P-ID dispositioned with landing + cite; NOT-fit addressed; no triple-mapped
category; no dangling IDs.

## Phase 4 — S5B groups + briefs → Blocks A+B

**Do (S5B):** group S5A by buyer into GRP-IDs: `grouping | archetype | segment | jobs |
pains | budget | buyer | channel | Top S-IDs | positioning ((a) vs (b) mix) |
objection | motion` (overlay nouns). Cover the real grouping span. Then **one brief per
group** (core: paragraph + 3 points + call; O-GTM: paragraph + 3 hooks + CTA in the
segment's wording tier, T6). **Briefs ship with groups** — a fit table alone repeats
failure S5-1.
**Do (bridge):** emit `S5B_GROUPS.csv` annex = Block A definition columns + Block B
logic columns (`AUDIENCE-POSITIONING-BRIDGE.md`). This is the handoff artifact.

**Gate:** brief count = group count; segment mix explicit (O-GTM: B2C/SMB/ENT/GOV);
motion per group in overlay terms; group nouns inside registry.

## Phase 5 — Brand Stage 0 (import) → Stage 1 → Gate 2

**Do (Stage 0):** declare Provider Profile first (Step 0-A — already drafted in Phase 0,
re-confirm). Collect brief Q1–Q10 conversationally (≤3 questions at a time,
`help me with this` → 2–3 options + trade-offs). **Import, don't re-invent:**
`AUDIENCE:` = S5B group table reference; `POSITIONING:` = Block B logic columns;
claims/constraints = S0 registry. Then Gate 1 approval (brief approved before any
reference analysis).
**Do (Stage 1):** deconstruct the Phase-2-selected reference on all 12 axes (idea,
composition, hierarchy, type/color behavior, photo/illustration, lighting/materials,
white-space, devices, placement, tone, scalable principles) → Transferable Principles
/ Must-Not-Copy (seed with P-ID must-not-resemble set + S5A NOT-fit) / Translation
Opportunity (mapped to category + positioning + audience + difference) → one
creative-direction statement constrained by `theme_sharp`. Then Gate 2 approval
(principles + prohibitions + direction). No kit generation before Gate 2.

**Gate:** Gate 1 (brief) then Gate 2 (direction) both explicitly approved.

## Phase 6 — Brand Stage 2 → Stage 3 → Gate 3 (Anchor)

**Do (Stage 2):** propose 1–2 font systems first (exact family + source + role, default
Google Fonts; paid only with confirmed license recorded as Approved Font Source), get
typography approval, present Generation Plan, then generate **one** coherent
exploratory kit (logo/wordmark, color, type with visible font labels, one device,
packaging/touchpoint concept, photo/media direction, one key visual, white space).
Summarize intended rules in ≤10 bullets. Not the anchor yet.
**Do (Stage 3):** audit as creative director → KEEP / REMOVE / REFINE + one simplified
direction. Then classify: **REFINE** (localized: spacing, one color/material/mockup/
hierarchy/detail) vs **REJECT AND RESTART** (foundational: mood, type, color logic,
materials, pack architecture, hierarchy, photo direction, audience fit, price tier —
or second refinement still inconsistent, contradictory typography, or "fundamentally
wrong"). Restart = mark `REJECTED — DO NOT USE AS A VISUAL REFERENCE`, keep only
abstract KEEPs, never reuse the rejected board as a generation reference, fresh
concept + new Generation Plan. Never blend rejected + replacement (mixed fonts/colors/
artifacts). Offer Creative Director Support Mode when feedback is vague/conflicting
or gates block (`WHAT IS WORKING / WHAT MAY FEEL WRONG / WHY FOR THIS AUDIENCE /
KEEP-REMOVE-REFINE / recommendation / 2–3 options / 1 pick`, no generation until
chosen). Cross-check the kit against the bridge BEFORE Gate 3 (this is where
Complementarity points 3–5 and Duplication rows 4 + 7 become executable):
- Money→mood (S3 stakes encoded, not just scored): high-`failure_cost` groups must read
  trust — cert lockups, contrast, spacing, approved-claims strictness given visual weight;
  high-`direct_ticket` groups may read premium — material/lighting language; livelihood-tier
  rows get subsistence-appropriate palette/imagery, never forced-decade premium cues. A kit
  that prices wrong fails here, not in market.
- Block B expression columns filled here: VISUAL-ENCODING of the wedge (e.g. compatibility
  → side-by-side lineup + label-zone lockup); TYPOGRAPHY/HIERARCHY ROLE per the group's T6
  wording tier (prosumer-concrete vs enterprise-formal rendered through type roles and
  headline hierarchy, never as two kits); ANTI-PATTERNS from P-IDs + rejected directions.
- NOT-fit boundaries respected visually (must-not-resemble P-IDs + prohibited styles).
- Gate mapping holds both ways: S5A NOT-fit non-empty (or justified) ↔ Anchor approval;
  S5B brief count = group count ↔ no test-asset scale before audit APPROVED. A red on
  either side blocks Gate 3.
Then Gate 3 — Anchor approval sets
`ANCHOR STATUS: APPROVED` and locks rules in the checkpoint.

**Gate:** Gate 3 explicitly approved; locked rules + prohibited styles recorded.

## Phase 7 — Brand Stage 4 → Stage 5 (guidelines + key visual + thread matrix)

**Do (Stage 4):** ask which guideline modules are needed (recommend minimum for the
deliverables); generate **exactly one 16:9 slide per module** from the Anchor only
(Logo, Typography, Color, Graphic Elements, Photo/Media, Key Visual Rules, Packaging,
Do's and Don'ts), each legible standalone, reviewed separately. Provider fallback: if
the generator can't hold 16:9 or legible text, closest ratio + finish type in the
layout tool, recorded in the Generation Plan.
**Do (Stage 5):** build the master key visual (composition, placement, headline
hierarchy, color, media treatment, device, claims, white space) then apply across
`{{SKU_LIST}}` — change only approved SKU variables. Side-by-side check: different
brands → stop, audit. **Joint step:** fill Block A activation columns here — one
thread row per (GRP-ID × scene × SKU-subset × format) with headline/promise copied
from that group's brief (no new copy), proof-points ≤3, CTA hardness from motion,
visual notes honoring sector_tags.

**Gate:** all modules reviewed before campaign work; key visual holds across SKUs;
every addressed group has ≥1 thread row (rest marked `unaddressed`).

## Phase 8 — Brand Stage 6 → Gate 4 → Stage 7 → Stage 8 → Stage 9 (lock, audit, correct, scale)

**Do (Stage 6):** Brand Lock setup — declare the 5 inputs (scene ref from a Top-K
S-ID moment, Anchor, pack/product ref from S4 realities, prohibited list from
NOT-fit + must-not-resemble P-IDs, desired output) and confirm the 3 reference roles
(scene inspires composition/shot/lighting/material/depth/rhythm/mood only; kit
controls identity; pack ref controls shape/architecture/zones). Original execution
only — no one-to-one recreation; likeness requires confirmed rights. Then **Gate 4**:
confirm roles, generate **one test asset**, no scaling before audit.
**Do (Stage 7):** audit the test asset (logo, type, colors/SKU logic, device, pack
shape/zones, claim accuracy, role compliance, prohibitions, scene contamination) →
PASS list / FAIL list / SEVERITY / CORRECTION / PRESERVE → verdict APPROVED /
CORRECTION REQUIRED / REJECT AND REGENERATE. Do not scale on anything but APPROVED.
**Do (Stage 8):** correct from the audit (PRESERVE + CORRECT lists, identity from
Anchor, product from pack ref, no new fonts/colors/devices/claims/scenes), one
corrected asset, re-audit.
**Do (Stage 9):** expand the approved direction across `{{SKU_LIST}}` ×
`{{OUTPUT_FORMATS}}` changing only `{{APPROVED_VARIABLES}}`; organize by
scene/SKU/format; flag inconsistencies instead of silently accepting.

**Gate:** Gate 4 roles confirmed; test asset APPROVED post-audit before any scale.

## Phase 9 — Brand Stage 10 → Stage 11 + M0

**Do (Stage 10):** packaging concept views (front / three-quarter / isometric / lineup /
label-architecture / optional exploded) with consistent studio presentation. Label as
**conceptual visualizations only** — never dielines, vectors, prepress, 3D models, or
manufacturing specs.
**Do (Stage 11):** final system review (anchor reflected everywhere? SKU differences
controlled? references within roles? type/color/pack consistent? claims accurate?
prohibitions absent? handoff-able? concepts labeled?) → completion report including
`MEASUREMENT BASELINE` pointer. **Joint step (M0):** write `M_PREDICTIONS.csv` — one
falsifiable row per scaled thread with kill + reposition conditions, owner, date
(pre-launch: 5-person confusion/recall probes + cost actuals).

**Gate:** review checklist passes; every scaled thread has an M0 row or
`STATUS: unaddressed`.

## Phase 10 — M1 → M2 → M3 → M4 (market loop)

Full spec: `MEASUREMENT-LOOP.md`; icp hook: `icp/references/M_measurement.md`;
brand hook: Bonus E. File set for the run: `M0_BASELINE.md`, `M_PREDICTIONS.csv`,
`M1_INSTRUMENT.md`, `M2_OBS.csv`, `M3_DECISIONS.md` (M4 writes go to owning artifacts),
prefixed with the run ID.
**Do (M1):** instrument before any spend — one tracked CTA per thread (UTM/code/QR/
rep-task-ID per overlay), one confusion probe per NOT-fit boundary (must-not-resemble
P-ID as an option), one cost line per asset in the profile's cost unit + human
finishing minutes, placement context (channel enum + format + flight dates). Untracked
threads do not fly.
**Do (M2):** collect append-only (leading weekly / per-1k impressions / per-5 sales
calls; lagging per motion cycle — PLG 2 weeks, enterprise per pipeline review, OPS/EDU
per exercise/cohort, subsistence per market-day with staple-equivalents).
**Do (M3):** judge per PRED-ID with all three metric sets — strategy-validity
(brief→response, objection-overcome, wedge-recall, NOT-fit precision, stakes
calibration error), craft-consistency (audit PASS rate, correction cycles, text-defect
rate, cross-SKU recognition, hierarchy survival, minutes vs estimate), joint efficiency
(cost per response/event, kill latency trip→kill). Verdicts: SCALE / FIX-CRAFT → brand
correction loop (expression works, bet untested — do not reposition) / FIX-LOGIC →
reopen S5A-S5B for that GRP-ID (bet wrong, kit works — do not redesign) / FIX-BOUNDARY
→ NOT-fit + prohibited-styles + re-probe / FIX-PROVIDER → profile workaround /
KILL thread (keep group) or KILL group (retire by note, never delete — count gate
preserved). **Never reposition on leading metrics alone; never average across GRP-IDs —
one winning thread never covers two dead ones.**
**Do (M4):** feed back to owning artifacts only — S3 `price_note`+anchors (stakes
miscalibration), S5A verb/wedge supersede with new landing+cite, old row kept
(verb wrong), S5B brief rewrite for that GRP-ID (objection wrong), Anchor amendment via
`GO BACK` with downstream invalidation stated (deviation that outperformed), S4 findings
+ NOT-fit + prohibited-styles (P-ID confusion), profile fallbacks (provider limits),
SKU/format/channel realities → S4 completion + S5B channel/motion notes. Then re-gate
→ re-render toggles (T1–T7) and Bonus A–D from amended sources. Never re-run cores to
chase a render.

## Resume / failure quick-index

- Resume icp-6 by artifact (S0/S1/…); resume brand by `STATUS` → `NEXT ACTION`
  (`RESUME`); reopen a brand stage with `GO BACK` (states downstream invalidation);
  audit without generating (`AUDIT`); kill a direction (`REJECT DIRECTION`); stop
  everything (`STOP`).
- Gate red → `icp/references/failure_modes.md` cure + brand audit/Creative-Director
  mode; fix the stage, re-run downstream (count-gate mismatches always propagate
  downstream). Common joint failures: brief invented instead of imported (re-import
  S5B); wedge-less visuals (return to S5A); rejected-board reuse (restart clean);
  scaling on CORRECTION REQUIRED (re-audit first); averaging metrics across GRP-IDs
  (judge per PRED-ID).
