# Illustration 1 — Joint run, end to end (fictional SunJar SHS-200)

Orchestration: `bridge/JOINT-RUN-ORCHESTRATION.md`. This document walks every phase
with concrete artifacts so you can see exactly what gets written, approved, and gated.
Running example is **fictional**: SunJar SHS-200, a pay-as-you-go 200W solar home
system (panel + battery hub + app) for off-grid households and roadside shops.
**All figures are illustrative, not market data.**

Miniature scale: N=6 S-IDs, 6 P-IDs, 3 groups. A real run enumerates the full
A1–A14 + B1–B13 skeleton; the mechanics are identical, only N is larger.
Machine-readable miniature of the icp/bridge artifacts lives in `data-joint/`
(`icp/S0_SPEC.md` … `S5B_GROUPS.csv`, `bridge/THREADS.csv`,
`bridge/M_PREDICTIONS.csv`, `GATES.log`). Every H1 line quoted below is the real
output of `hooks/Validate-Gates.ps1` on `data-joint/` (full log: `hook-joint.txt`).

## Phase 0 — Setup

Run ID `sunjar-001`. Folders `runs/sunjar-001/{icp,brand,bridge}`. Naming fixed:
`S-0001`, `P-0001`, `GRP-ID`, `PRED-ID`. Provider Profile declared (image: GPT-image
class generator; video: Runway; layout: Figma for type finishing; fonts: Google Fonts;
cost unit: USD + staff minutes; capability flags: no exact text-in-image → fallback is
finish all pack copy in Figma, recorded in every Generation Plan). Subject form
`physical` (Q0.6); context pack accepted (Q0.7, 5 sources in `SOURCES.log`);
binding `cert-regime national wiring code plus CE` (Q0.8).

## Phase 1 — S0 freeze → S1 fork

S0 sources (codebase README, 2 spec notes, agent price sheet) are dumped to
`Appendix_Raw.md` with SHAs; the normative `S0_SPEC.md` stays short (see
`data-joint/icp/S0_SPEC.md`). Load-bearing lines:

- Header stamps `run-mode single` (one offering) and `overlay O-GTM`.
- `Out-of-Scope` names grid-tied installs, refrigeration, mains-wired loads, and
  school fixed wiring — this list later becomes brand's prohibited-claims seed and
  S5A's X-rows.
- Acceptance test: 5 pilot homes × 4 lamps + 2 phones × 14 nights, zero kerosene.

S1 runs RTD L0→L6 with battery table and records the fork:

- `theme_broad`: `off-grid home power` (TAM view)
- `theme_sharp`: `paid-off-grid-light` (Need-qualified view; this run is tagged sharp)
- Run-mode read: `single` → `(a)` means full swap; challenger positioning is licensed.

Gate: Out-of-Scope present, quotas stamped, worksheet + battery saved, fork recorded.

## Phase 2 — S2 situations → S3 stakes → reference selection

S2 emits 6 rows (`data-joint/icp/S2_SITUATIONS.csv`), each with ≥1 substantive lens
and N/A lenses carrying reasons (e.g. S-0004 action_moment substantive on ice-packing
while knowledge_need is `N/A: cooling is thermodynamic not informational`). Plus the
bulleted companion (6 bullets, one per S-ID).

S3 scores both lenses per S-ID. Two rows that do downstream work:

- S-0002 (stall): `direct_ticket 60 / failure_cost 900` — the extra-hour margin prices
  the SMB offer; the night-fire figure weights trust cues in the kit.
- S-0006 (evening classes): `direct_ticket 0` with `no_direct_ticket: community vote
  moves no household spend` — the $0-flag rule firing exactly as designed.

Derived views (no re-run): decade rank puts S-0005 first; livelihood re-score keeps
S-0001/S-0003/S-0004 together for the subsistence read.

**Reference selection (joint step).** Candidate references are tested against Top-K
scenes (S-0001 bedroom, S-0002 stall canopy, S-0005 rooftop). Winner: a matte-charcoal
lantern product shot with a single amber glow zone — stretches across bedroom, stall,
and install scenes; recorded in one stretch paragraph. The old habit (pick the
prettiest reference) is explicitly refused.

Gate: N=6 everywhere; currency/year/PPP stated; every $0 flagged; stretch note written.

## Phase 3 — S4 catalog → S5A fit

S4 lists 6 P-IDs USED FOR the situations (`data-joint/icp/S4_PRODUCTS.csv`): kerosene
vendors, petrol generators, the LuminaHome SHS-200 rival, street charging kiosks
(human-service), ice-block vendors, mobile-money SMS receipts (digital, N/A economics).
Zero fit tags. Catalog sections: coverage 6/6; **white-space**: no PAYG product serves
S-0006 evening classes; **graveyard**: dead kerosene-subscription pilots; finding:
LuminaHome owns the dealer shelf (blue packs) — first sighting of the confusion risk.

S5A dispositions 10 rows (`data-joint/icp/S5A_FIT.csv`). The verdicts that matter:

- `(S-0001, P-0001, (a))` — full swap of the bedroom lantern (challenger claim licensed
  by single mode).
- `(S-0002, P-0006, b-FACE)` — app as query face over SMS receipts (digital verb on a
  digital P-ID; legality holds).
- `(S-0004, P-0005, X)` — 200W cannot refrigerate; cooling claims forbidden.
- `(S-0005, P-0003, b-SERV)` — agents service both kits on transition accounts.
- K-fit Top-3: bedroom swap, kiosk swap, stall-generator retirement. NOT-fit +
  SAFETY (certified agents; swap-don't-open hubs) in `NOTFIT.md`.

Joint outputs: must-not-resemble set {P-0003 blue packs, P-0001 lantern silhouette},
K-fit Top-3, NOT-fit boundaries.

## Phase 4 — S5B groups + briefs → Blocks A+B

Three groups with one brief each (`data-joint/icp/S5B_GROUPS.csv`): GRP-01 off-grid
mothers (B2C, PAYG direct, S-0001/03/06), GRP-02 stall traders (SMB, agent dealer,
S-0002/03), GRP-03 field agents (direct enablement, S-0005). Each brief is one
paragraph + 3 hooks + CTA in its wording tier — e.g. GRP-01 CTA: "ask your SunJar
agent for a 7-day home trial." Brief count = group count.

Block A definition columns + Block B logic columns ship as the handoff. Logic excerpt
for GRP-01: verb-mix `(a)` on lighting situations; wedge n/a in single mode (full
swap); landing "wall-rail lamp point, §3.2"; NOT-fit boundary "no cooling, no
mains-tie"; objection "looks like LuminaHome" → answer "amber rail + 7-day trial,
blue packs have no rail".

## Phase 5 — Brand Stage 0 (import) → Stage 1 → Gate 2

Stage 0 re-confirms the Provider Profile, then imports: AUDIENCE = S5B table
reference; POSITIONING = Block B logic; claims = S0 registry. No second audience
list is written. Gate 1 approves the brief.

Stage 1 deconstructs the charcoal-lantern reference on all 12 axes. Transferable:
single-glow-zone composition, matte/amber material tension, generous dark negative
space. Must-not-copy (seeded from S4/S5A): LuminaHome blue-pack architecture,
lantern silhouette, any cooling/pack claims. Translation Opportunity maps the glow
logic onto category + sharp theme + three groups. Direction statement:
"One amber rail of paid light in a matte charcoal world." Gate 2 approves
principles + prohibitions + direction.

## Phase 6 — Stage 2 kit → Stage 3 review → Gate 3 Anchor

Stage 2: two font systems proposed first (A: Archivo display + Inter body; B: Space
Grotesk + Inter). System A approved with roles. Generation Plan (profile, cost, fonts
+ source, prohibitions incl. P-0003 blue, formats, text-in-image fallback to Figma)
approved. One exploratory kit generated; rules summarized in 10 bullets.

Stage 3 audit → KEEP (amber-rail device, charcoal/amber logic, Archivo/Inter,
wall-rail pack zone), REMOVE (second teal accent, competing rounded icon set),
REFINE (rail thickness rule, lamp-point spacing). Verdict **REFINE** (localized).

Pre-Gate-3 bridge check (the executable version of the analysis):

- Money→mood: GRP-02's failure_cost weight → cert lockup + claim-zone strictness get
  visual priority; GRP-01 livelihood rows → no premium cues, matte honesty.
- Block B expression filled: compatibility wedge → side-by-side rail lineup +
  label-zone lockup; T6 tiers → prosumer-concrete headlines for GRP-01/02, formal
  proof blocks for agent/school readers — one kit, two registers.
- Gate mapping: NOT-fit non-empty ↔ Anchor; brief=group ↔ no scale before audit PASS.

Gate 3: `ANCHOR STATUS: APPROVED`; locked rules + prohibited styles in checkpoint.

## Phase 7 — Guidelines → key visual → thread matrix

Stage 4: five modules (Logo, Typography, Color, Packaging, Do's and Don'ts), one 16:9
slide each, reviewed separately; pack copy finished in Figma per the recorded fallback.
Stage 5: master key visual (amber-rail composition, headline zone above rail,
claim zone on pack face, white-space rule) validated across 3 SKUs — change only
approved SKU variables. Block A activation columns filled: GRP-01 → amber bedroom
4:5; GRP-02 → stall canopy 4:5; GRP-03 → rooftop install 16:9.

## Phase 8 — Lock → Gate 4 → audit → correction → scale

Brand Lock roles confirmed: scene refs (bedroom/stall/rooftop moments) inspire
composition/lighting only; Anchor controls identity; S4 pack realities control
shape/zones. Gate 4: one test asset (GRP-01 bedroom). Stage 7 audit returns
**CORRECTION REQUIRED** (major: label zone borrowed LuminaHome blue adjacency;
minor: rail 2px under spec) with PRESERVE (composition, lighting, headline tier).
Stage 8 corrects exactly that; re-audit **APPROVED**. Stage 9 scales the approved
direction across SKU × format matrix, organized by scene/SKU/format.

## Phase 9 — Packaging → Stage 11 + M0

Stage 10: front / three-quarter / lineup / label-architecture views, labeled
conceptual-only. Stage 11 review passes; M0 writes `M_PREDICTIONS.csv`: PRED-01
(GRP-01 bedroom 4:5 — pause if trial requests < 1.0/100 impressions after 1000;
reopen brief after 3 price-lost pitches). GRP-02/03 threads are `planned` and do not
fly until they get M0 rows.

## Phase 10 — M1→M4 (first flight, GRP-01)

M1 instruments the tracked trial-request link, a confusion probe (must-not-resemble
P-0003 as an option), and cost lines. M2 collects 3 weeks. M3 judges PRED-01:

- Trial-request rate 1.6/100 (leading ✓), 7-day trials converting to PAYG at plan
  (lagging ✓) → **SCALE** GRP-01; write M0 rows for GRP-02/03 next.
- Confusion-with-LuminaHome 4% → **watchlist**, below the 10% FIX-BOUNDARY trip:
  no rework, probe stays in flight.
- The decision explicitly not taken: no repositioning on leading metrics alone, no
  kit redesign on a logic question — the FIX-CRAFT vs FIX-LOGIC split holds.

M4 writes back: S3 `price_note` appends observed trial rate to the S-0001 anchor;
brand prohibited-styles gains "blue-adjacent label fields (watch, 4%)"; Provider
Profile fallback (Figma type finishing) marked validated. Toggles re-render from
amended sources; cores untouched.

## Hooks (real output, `hook-joint.txt`)

Full H1 run green — 41/41, including the-X exclusion that initially tripped on the
numbered `# 6. Out-of-Scope` heading (validator now accepts the skill's own numbered
template; the gate caught a real shape mismatch before any downstream stage ran):

```text
PASS: [G1-header] header fields present
PASS: [G6-honesty] Out-of-Scope section non-empty
PASS: [E-sources] SOURCES.log has 5 source line(s) (min 1, recommended 5)
PASS: [E-sources] every source line carries a family tag F1-F6
PASS: [E-sources] S0 spec-sha stamped and non-placeholder (sunjar001)
PASS: [E-sources] spec-sha resolves in SOURCES.log (dangling spec-sha is red)
PASS: [G2-count] S2 rows=6 S3 rows=6 (must match, >0)
PASS: [G3-ids] all S-IDs match S-0001 shape
PASS: [G3-ids] S-IDs unique
PASS: [G3-ids] no dangling S-IDs in S3
PASS: [G3-ids] sector_tags empty or SEC-KEY shape (custom-key definitions → H2)
PASS: [G5-lenses] every row ≥1 substantive lens (H1 presence; substance → H2)
PASS: [G5-lenses] bare N/A without reason absent
PASS: [G5-bullets] bulleted companion has 6 bullets for 6 S-IDs
PASS: [G5-zero] $0 rows all flagged (priceless_flag or no_direct_ticket reason)
PASS: [G5-fitban] zero (a)/(b) tags in S4
PASS: [G3-ids] all P-IDs match P-0001 shape
PASS: [G3-ids] P-IDs unique
PASS: [G5-physical] physical/hybrid rows complete (unit_economics+channel+warranty_reg, channel in registry)
PASS: [G2-count] every S-ID ≥1 P-ID
PASS: [G5-rows] every fit row has landing_place + spec cite (presence; specificity → H2)
PASS: [G2-count] every P-ID dispositioned
PASS: [G3-ids] no dangling P-IDs in fit
PASS: [G3-ids] no dangling S-IDs in fit
PASS: [G5-verbs] no software-only verb on pure-physical P-ID
PASS: [G6-honesty] NOT-fit non-empty or justified (NOTFIT.md)
PASS: [G5-groups] brief count = group count (3 groups)
PASS: [H3-approval] Gate1 approval token present in GATES.log
PASS: [H3-approval] Gate2 approval token present in GATES.log
PASS: [H3-approval] Gate3 approval token present in GATES.log
PASS: [H3-approval] Gate4 approval token present in GATES.log
PASS: [H1-verdict] audit APPROVED token present before scale
PASS: [B-threads] every group has a thread row or explicit unaddressed
PASS: [B-m0] every prediction has kill + reposition conditions (1 rows)
PASS: [B-m0] every scaled thread has an M0 row
PASS: [E-ask] report brief (QRP.1) recorded for this flight
PASS: [E-ask] S0 elicitation complete (mode + profile + form + pack + binding + run-mode + overlay + quotas + claims seed + working title)
PASS: [E-ask] grouping check asked before briefs lock
PASS: [E-ask] guideline modules chosen by user
PASS: [E-ask] kill/reposition thresholds accepted per thread
PASS: [X2-naming] file naming clean
RESULT: GREEN (all H1 checks pass)
```

Resume pointers: icp by artifact (`S5A_FIT.csv` …), brand by checkpoint (`STATUS` →
`NEXT ACTION`), measurement by M-file chain. H2 substance calls (lens quality, landing
specificity, audit rubric) and H3 approvals are recorded in `data-joint/GATES.log`.
