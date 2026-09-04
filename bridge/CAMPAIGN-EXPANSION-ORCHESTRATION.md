# Orchestration 3 — Campaign Expansion Only (system exists → more assets)

When to use: Anchor is approved, Brand Lock passes, and the job is **more assets**:
new scenes, SKUs, formats, localizations, motion, or platform extensions — no new
positioning, no identity change. If positioning is in doubt, use
`JOINT-RUN-ORCHESTRATION.md` (Phases 3–4 first). If the identity itself must change,
use `REBRAND-ORCHESTRATION.md`. This run **creates zero new strategy and zero new
identity**: every word comes from an existing S5B brief, every pixel from the Anchor.
Companion contracts: `AUDIENCE-POSITIONING-BRIDGE.md`, `MEASUREMENT-LOOP.md`.

## Entry gates (all three, no exceptions)

1. `ANCHOR STATUS: APPROVED` with locked rules + prohibited styles in the checkpoint.
2. Brand Lock roles confirmed **and** at least one test asset at `APPROVED` post-audit
   for the direction being expanded (a new scene family needs its own test asset first).
3. M0 predictions exist for the threads being scaled (or are written in Phase 1 below
   before flight). Untracked threads do not fly.

**Missing-gate spine:** no Anchor → stop, run joint-run Phases 5–6 first. No S5B brief
for the target group → stop, run joint-run Phase 4 first (brand never invents copy to
fill a layout). Stale brief (market moved) → delta S5B for that GRP-ID only, then return.

## Run map

```text
ENTRY-GATE CHECK
→ Phase 1: thread plan (which GRP × scene × SKU × format, from Block A; M0 rows)
→ Phase 2: per-thread execution (roles → plan → test asset → audit → correct → scale → organize)
→ Phase 3: lateral additions (new SKU / new scene family / new format / new group)
→ Phase 4: Bonus extensions (A responsive / B localization / C motion / D social-banner)
→ Phase 5: M1–M4 per flight → feed back → re-render
```

## Phase 1 — Thread plan

**Inputs:** Block A activation table, S5B briefs, Anchor rules, Brand Lock roles,
Provider Profile, M-history (M3 decisions: what scaled, what was killed and why).
**Do:**
1. `STATUS` checkpoint review: Anchor version, active references + roles, locked rules,
   prohibited styles, open issues, deliverables to date. `RESUME` from `NEXT ACTION`
   only after confirming inputs still exist (pack refs current? SKU list current?
   briefs still valid?).
2. Build the thread table — one row per planned asset: `GRP-ID | THREAD-SCENE
   (S-ID-grounded moment) | SKU-SUBSET | FORMAT | brief source (GRP-ID + hook IDs,
   verbatim) | proof-points ≤3 | CTA hardness (from motion) | variables allowed to
   change (the ONLY delta for Stage 9)`.
3. Write/confirm M0 rows per thread (prediction + kill + reposition conditions, owner,
   date). Pre-launch/small runs: 5-person confusion/recall probes + cost caps.
4. Sequence flights: proven directions first (fund new bets with winners' learnings),
   one new scene family at a time (each needs its own test-asset + audit before scaling).

**Gate:** thread table complete; brief source cited per row (no sourceless rows); M0
rows or explicit `unaddressed` (unaddressed rows do not fly); Generation Plan budget
approved in the profile's cost unit.

## Phase 2 — Per-thread execution loop (repeat per thread row)

1. **Confirm Brand Lock roles** for this scene (Gate-4 discipline every time, not just
   once): scene ref inspires composition/shot/lighting/material/depth/rhythm/mood only;
   Anchor controls identity; pack ref controls shape/architecture/zones; prohibitions
   listed. Original execution only; likeness needs confirmed rights.
2. **Generation Plan + explicit approval.** Name provider profile + model, cost, objective,
   deliverable, inputs, refs + roles, locked vs changeable, exact fonts (family + source
   + role), prohibitions, count + formats, capability workaround if any. No tool call
   before approval.
3. **One test asset first** for any new scene family / SKU architecture / format class.
4. **Audit** (logo, type, colors/SKU logic, device, pack shape/zones, claim accuracy,
   role compliance, prohibitions, scene contamination — plus: headline still verbatim
   from the cited brief (no layout-invented copy), T6 wording tier preserved through
   type/hierarchy roles, CTA hardness matches motion) → PASS / FAIL / SEVERITY /
   CORRECTION / PRESERVE → APPROVED / CORRECTION REQUIRED / REJECT AND REGENERATE.
   Scale only on APPROVED.
5. **Correct** from PRESERVE + CORRECTION lists (no new fonts/colors/devices/claims/
   scenes); single corrected asset; **re-audit**.
6. **Scale** the approved direction across the row's SKUs × formats, changing only the
   approved variables. **Organize by scene, SKU, format; flag inconsistencies instead of
   silently accepting.**
7. Log cost actuals + production minutes per asset (M2 input).

**Gate per thread:** test asset APPROVED post-audit before scale; corrected asset
re-audited; outputs organized + flagged.

## Phase 3 — Lateral additions (each reopens exactly what it must, nothing more)

| Addition | Reopen | Do not touch |
|---|---|---|
| New SKU, same architecture | Stage 5 SKU validation for that SKU + thread rows + M0 rows; then Phase 2 loop | Anchor, guidelines, briefs |
| New scene family (new moment/setting) | New scene ref → Gate-4 role confirmation → fresh test asset + audit (Phase 2 steps 1–4) before scaling | Anchor, briefs (headline still verbatim from group brief) |
| New format / aspect class | Bonus A recompose (never plain crop) + safe-area check + hierarchy survival check; new test asset if composition changes materially | Identity, copy |
| New language market | Bonus B with approved translation mapping only; adjust breaks/spacing; flag legal/linguistic review items; never invent translations | Logo form, hierarchy intent |
| New buyer group | **Leave this run.** Delta S5B (group + brief + Block A/B rows + M0) first, then return with a brief source | Do not brief-by-layout |
| New product claim / cert / wedge | **Leave this run.** Back to S5A/S5B (landing + cite + regime) — claims enter through strategy, not through art | Do not claim-by-layout |
| Provider/toolchain change | Update Provider Profile + fallbacks; re-issue pending Generation Plans; re-probe text/aspect/motion limits | Everything else stays locked |

`GO BACK` mechanics: name the stage being reopened and state which downstream outputs
become invalid (invalidated test assets are marked, never silently reused).

## Phase 4 — Bonus extensions (order matters)

1. **A — Responsive first:** recompose per `{{OUTPUT_FORMATS}}` preserving system,
   prominence, type, devices, media; respect safe areas; flag formats needing material
   recomposition (those loop Phase 2 steps 3–5).
2. **B — Localization:** mapped translations only, logo untouched, hierarchy/roles kept.
3. **D — Social/banner:** platform-adapted composition (not generic crop), concise
   approved-claims-only copy + CTA.
4. **C — Motion last** (needs locked stills): `{{DURATION}}` from approved still with
   motion direction + camera behavior + aspect; preserve product/pack/logo/type/colors/
   claims/composition; no new products/text/details/characters/transitions unless
   requested; watch logo mutation, text distortion, shape change. No motion-capable
   provider → storyboard + shot-list + motion-direction spec, recorded substitution.

**Gate:** each extension audited against Anchor + pack ref before it joins the scaled set.

## Phase 5 — M1–M4 per flight

Full spec: `MEASUREMENT-LOOP.md`. File set per flight: `M_PREDICTIONS.csv`,
`M1_INSTRUMENT.md`, `M2_OBS.csv`, `M3_DECISIONS.md` (run-ID prefixed).
Instrument (tracked CTA + confusion probe per NOT-fit boundary + cost line + placement
context) → collect append-only `M2_OBS.csv` (leading weekly/per-1k/per-5-calls; lagging
per motion cycle; subsistence per market-day) → judge per PRED-ID with all three
metric sets (strategy-validity / craft-consistency / joint efficiency — never
reposition on leading metrics alone: high CTR + no conversion is FIX-LOGIC, low CTR is
FIX-CRAFT) (SCALE the thread /
FIX-CRAFT back to correction loop / FIX-LOGIC exits to delta S5A-S5B / FIX-BOUNDARY
extends NOT-fit + prohibited-styles + re-probe / FIX-PROVIDER updates profile
workarounds / KILL thread or retire group by note) → feed back to owning artifacts →
re-gate → re-render toggles and extensions from amended sources. Kill latency (trip →
actual kill) is tracked as the loop's own KPI. Averaging across GRP-IDs is forbidden —
one winning thread never covers two dead ones.

## Stop / pause rules

- `STOP`: halt all generation, return the checkpoint (costs stop, knowledge kept).
- Audit `REJECT AND REGENERATE` twice on one thread → pause the thread, run Creative
  Director Support Mode (no generation until a direction is chosen), or kill per M3.
- Any request that changes positioning, claims, groups, or identity → exit to the
  owning run (joint or rebrand); this orchestration cannot approve those changes.
