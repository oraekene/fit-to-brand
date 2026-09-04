# Illustration 2 — Rebrand (fictional SunJar, two years later)

Orchestration: `bridge/REBRAND-ORCHESTRATION.md`. Continues the SunJar story from
`ILLU-JOINT-RUN.md`: the v1 identity ships, then two field facts force a rebrand —
(1) dealer-shelf confusion with LuminaHome blue packs has crossed the 10%
FIX-BOUNDARY trip (observed 14%), and (2) the matte-charcoal look mis-signals a
budget tier against a mid PAYG price. **All figures are illustrative, not market data.**
Miniature artifacts in `data-rebrand/` (regrouped `S5B_GROUPS.csv`, migration
`THREADS.csv`, `M_PREDICTIONS.csv`, `GATES.log`); quoted H1 lines are real outputs
(`hook-rebrand-s5b.txt`, `hook-rebrand-m.txt`).

## Phase 0 — Setup + equity guardrails (approved before any diagnosis)

Corpus assembled: v1 kit, 5 guideline slides, live assets by scene/SKU/format, flight
history, confusion log. Guardrails page, approved:

- Must-keep: amber-rail device, 7-day trial promise, wall-rail pack zone.
- Negotiable: charcoal ground, Archivo display, bedroom-first scene order.
- Must-drop: anything reading blue at 3 meters (the confusion source).
- Constraints: dealer sell-through window (old packs coexist 8 weeks), live PAYG
  contracts keep v1 claim wording until renewal.
- Rebrand kill trigger (M0 row about the rebrand itself): hold launch if new-vs-old
  recall < 60% after 30 probes.

No diagnosis ran before this page existed — the undiagnosed "fresh start" is exactly
what destroys equity silently.

## Phase 1 — S0 (the present, frozen) → S1 (theme verdict: evolve)

S0 freezes the capability **as it ships**: same template, Out-of-Scope now also lists
"v1 blue pack graphics (deprecated, see transition plan)". Run-mode stays `single`;
overlay stays O-GTM (no world change — stated explicitly, so nobody mistakes this for
an overlay switch).

S1 runs the worksheet on the live promise and returns **evolve**: broad holds
(`off-grid home power`), sharp refines from `paid-off-grid-light` to
`amber-rail-light` — the differentiator moved from the business model to the visual
signature. Old fork tagged for migration copy ("still SunJar, now amber by name").

## Phase 2 — S2/S3 reuse-or-refresh (reuse + delta, not a re-run)

Decision: market moments unchanged → **reuse** S2/S3 with a dated delta note, plus a
**delta pass** for one movement: S-0006 school lighting grew teeth (3 term contracts),
so S-0006 stakes are re-scored on both lenses with new anchors; IDs stable, no
renumbering, count gate re-balanced. Reference re-confirmed against refreshed Top-K;
the v1 look is explicitly barred from being the reference.

## Phase 3 — S4 (self on the shelf) → S5A (honest self-fit) → S5B (regroup)

S4 adds SunJar v1 itself as a P-ID with honest spans (mid PAYG price, dealer channel,
CE) and a finding that does the work: "v1 blue-adjacent label fields confuse with
P-0003 at 3 meters; charcoal ground under-signals the price tier by one band."

S5A self-match rows ship as `(b-COMP)`/`X` — never `(a)` (a brand cannot swap
itself). NOT-fit extends: "no blue-adjacent label fields", "no lantern-silhouette
iconography", "no budget-tier material cues at the mid price".

S5B regroup, one decision per group (`data-rebrand/icp/S5B_GROUPS.csv`):

- GRP-01 **keep**, brief rewritten to v2 ("the amber hub not the blue box … ask for
  the amber rail by name").
- GRP-02 **keep**, brief carried over with note.
- GRP-03 **retired by note, not deletion** (agent enablement folded into dealer ops;
  count gate preserved — the row stays with a retirement brief).
- GRP-04 **split** from GRP-01 evidence (school committees, termly payment, certified
  fitting). New brief, new M0 row.

Blocks A+B ship with `carry-over` vs `new` marked per column.

## Phase 4 — Audit the CURRENT kit first (Stage 3 before Stage 1)

The Stage 3 instrument runs on the live v1 kit: one direction? yes. Competing
languages? yes — blue-adjacent labels vs amber rail (the confusion, now diagnosed as
craft, not taste). Pack recognizable? no at 3 meters. SKU scalability? yes. Result:
KEEP (amber rail, trial promise, rail pack zone — each priced against guardrails),
REMOVE (blue-adjacent fields, lantern icon, budget-gray secondary), REFINE (rail
thickness, charcoal depth). Verdict: **REJECT AND RESTART** — foundational triggers
(color logic, pack architecture, price-tier fit). Restart mechanics honored: v1 marked
`REJECTED — DO NOT USE AS A VISUAL REFERENCE`, only abstract KEEPs survive, fresh
concept + Generation Plan, never blended. The rejected v1 remains the **migration
baseline** for old-vs-new pairs — isolated from generation, not from comparison.
Gate 3 re-Anchors the amber system; deprecation scope enters the checkpoint as OPEN
ISSUES. Pre-Anchor bridge check repeats (stakes re-encoded at the mid tier, Block B
expression for the amber wedge, extended NOT-fit, gate mapping).

## Phase 5 — Delta guidelines → key visual + migration pairs → lock/scale/pack

Stage 4 regenerates touched modules only (Color, Packaging, Do's and Don'ts with
old-vs-new misapplication examples); untouched modules carry over by note. Stage 5
validates the new key visual across SKUs and builds **migration pairs** — same
bedroom scene, old blue vs new amber — for every kept group; pairs are the unit of
probe and launch review. Stages 6–9: Brand Lock with old-look elements explicitly
prohibited, Gate 4, test asset, audit APPROVED, correction loop, scale across carried
+ new thread rows (`data-rebrand/bridge/THREADS.csv` — note GRP-03R's `retired` row,
which satisfies the thread-per-group gate without flying anything). Stage 10 adds the
transition plan: 8-week shelf coexistence, sell-through order, label-zone changes
sequenced by print lead time.

## Phase 6 — Stage 11 + M0 (old-identity probes) → M1–M4 → deprecation

M0 rows (`data-rebrand/bridge/M_PREDICTIONS.csv`): PRED-R1 covers launch-hold (recall
≥ 60%, LuminaHome confusion < 10%) and PRED-R2 covers the new GRP-04 wedge. Flight:
probes return 71% recall, confusion 6% → launch proceeds; GRP-04 books 3 term plans
in 20 visits → wedge holds. M4 writes: S4 findings close the confusion entry; S5B
GRP-01 brief v2 validated; prohibited-styles keeps "blue at 3 meters" permanently;
deprecation retires old assets per plan and archives v1 Anchor as `SUPERSEDED`
(kept for reference, never a generation input).

## Hooks (real outputs)

S5B regroup gate and M coverage gate, both green — the retired-by-note row is what
keeps the count gate honest:

```text
# -Stage S5B
PASS: [G5-groups] brief count = group count (4 groups)
PASS: [E-ask] grouping check asked before briefs lock
PASS: [X2-naming] file naming clean
RESULT: GREEN (all H1 checks pass)

# -Stage M
PASS: [B-threads] every group has a thread row or explicit unaddressed
PASS: [B-m0] every prediction has kill + reposition conditions (2 rows)
PASS: [B-m0] every scaled thread has an M0 row
PASS: [E-ask] kill/reposition thresholds accepted per thread
PASS: [X2-naming] file naming clean
RESULT: GREEN (all H1 checks pass)
```

What H1 cannot see here (H2/H3 territory, logged in `data-rebrand/GATES.log`): whether
the amber system actually cures the tier mis-signal (judge J5 + probe results), and the
four human approvals. The hook layer's honesty is that it says so.
