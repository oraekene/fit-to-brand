# Orchestration 2 — Rebrand Existing (live brand + live market → evolved identity)

When to use: a brand already ships (assets in market, customers, shelf/history) and the
identity must change — repositioning, confusion with an incumbent, stale price-tier
signals, architecture that can't stretch across SKUs. If nothing ships yet, use
`JOINT-RUN-ORCHESTRATION.md`. If the system is fine and only assets are needed, use
`CAMPAIGN-EXPANSION-ORCHESTRATION.md`.
Companion contracts: `AUDIENCE-POSITIONING-BRIDGE.md`, `MEASUREMENT-LOOP.md`.

Two differences from a joint run drive everything below: (1) the current brand is
**both an incumbent (S4 P-ID) and the Stage 3 audit subject** — it gets measured like
a competitor and diagnosed like a draft; (2) **recognition equity is a constraint** —
the restart rules still apply, but KEEP must explicitly price what survives, and a
migration/deprecation plan ships with the system.

## Elicitation spine (joint spine plus rebrand extras — Q-sets in `QUESTIONNAIRES.md`)

Same phase binding as the joint run (missing answers block via `Test-Params`), plus:

| Phase | ASK extra | Blocks exit until |
|---|---|---|
| 0 Setup | QR.1 (equity sort: must-keep / negotiable / must-drop) + Q0 re-confirm of toolchain | guardrails approved before any diagnosis |
| S5B regroup | QR.2 (per-group keep / kill / merge / split) on top of Q5.1–Q5.2 | regroup decision per group recorded |
| Transition | QR.3 (coexistence window; default 8 weeks) | sell-through timing in plan |
| Gate 3 re-Anchor | Q9.3 confirm explicitly includes deprecation scope | deprecation as OPEN ISSUES |
| M0 | confusion-with-OLD probe thresholds inside Q13.1; launch-hold via Q14.2 (no default) | hold conditions exist |
| N rename | QN-R.1 keep / evolve / replace (name equity priced) → N1–N5 if replace; QN.3 pick; QN.4 manual | renamed-or-kept decided before re-Anchor |
| Reports | QRP.1 per R-MIGRATION trigger | migration report briefed |

## Run map

```text
SETUP (equity guardrails + Provider Profile + run folders)
→ S0 (existing brand + market as sources; run-mode decision)
→ S1 (keep / evolve / replace theme fork)
→ S2/S3 (reuse-refresh decision → delta pass if needed)
→ S4 (self-as-P-ID + shelf realities) → S5A (self-match NEVER (a)) → S5B (keep/kill/merge groups)
→ Blocks A+B (carry-over vs new columns marked)
→ brand Stage 3-first: audit CURRENT kit as if it were the First Kit → REFINE vs REJECT-AND-RESTART (equity-priced)
→ Gate 3 (re-Anchor) → Stage 4 delta-guidelines → Stage 5 key visual + migration pairs (old vs new)
→ Stages 6–9 (lock, audit, correct, scale) → Stage 10 (pack transition) → Stage 11 + M0 (confusion-with-OLD probe required)
→ M1–M4 (old-vs-new readouts) → deprecation
```

## Phase 0 — Setup + equity guardrails

**Do:**
1. Run folders as in the joint run (`<run>/icp/`, `<run>/brand/`, `<run>/bridge/`), one run ID.
2. Re-confirm (or declare) the Provider Profile — rebrands often change toolchain
   (e.g. layout-tool finishing for type the old provider faked). Record fallbacks.
3. Write **equity guardrails** before any diagnosis (one page, approved):
   - Recognition assets ranked: must-keep (e.g. wordmark shape, hero color, pack silhouette)
     / negotiable / must-drop (contamination, confusion source, tier mismatch).
   - Hard constraints: legal (live trademarks, regulated claims), contractual (dealer/pack
     lead times, co-op windows), market (shelf windows, campaign flights that cannot break).
   - Kill triggers for the rebrand itself (e.g. "if new-system recall < old-system recall
     in probes, hold launch" — an M0 row about the rebrand, not just threads).
4. Assemble the corpus: current kit, guideline docs if any, live assets by scene/SKU/format,
   performance history (what worked per group, if known), complaint/confusion log.

**Gate:** guardrails + constraints + corpus index approved. No diagnosis before this —
undiagnosed "fresh starts" destroy equity silently.

## Phase 1 — S0 (the present, frozen) → S1 (theme verdict)

**Do (S0):** freeze a spec of the capability **as it ships today**, sourcing the live
product + live brand + market artifacts (dumps → `Appendix_Raw.md`, normative ≤ line-cap).
Out-of-Scope must include what the rebrand will **not** touch (e.g. product formulation,
SKU count, legal entity) — empty = fail.
- **Run-mode decision:** `single` if one offering swaps its identity; `category` if the
  whole line/category presence shifts (share-shift wedges, not swaps).
- Overlay: keep the live overlay unless the business truly changed worlds (GTM→OPS etc.
  is a re-run of nouns/channels/certs, not a rebrand tweak — say so explicitly).
**Do (S1):** run the RTD worksheet on the live brand promise, then deliver the verdict:
**keep** (theme validates — rebrand is expression-only), **evolve** (qualifier shifts,
e.g. broad holds + sharp refines), or **replace** (fork a new sharp; keep the old fork
tagged for migration copy). Never silently mix forks (T5).

**Gate:** S0 gates as usual + theme verdict recorded with worksheet/battery evidence.

## Phase 2 — S2/S3 reuse-or-refresh

**Decision tree (do not default to a full re-run):**
- If the market/situations are unchanged (same buyers, same moments): **reuse** S2/S3,
  re-confirm Top-K + stakes with a delta note (date, what was checked). Full re-enumeration
  without new evidence repeats failure S2-3 (volume sprawl) for no gain.
- If buyers, moments, channels, price tiers, or regulation moved: **delta pass** — add /
  retire S-IDs with reasons (keep IDs stable; retired rows marked, never renumbered),
  re-score touched S-IDs on both lenses with new anchors. Count gate must still balance
  (N = rows = coverage).
- Re-select or confirm the main visual reference against refreshed Top-K (stretch note
  as in the joint run — the old brand's look must NOT be the reference).

**Gate:** reuse note or delta pass balanced through the count gate; reference-stretch
note written.

## Phase 3 — S4 (self on the shelf) → S5A (honest self-fit) → S5B (regroup)

**Do (S4):** catalog incumbents **including the current brand as a P-ID** (own-stack-as-
positions, required catalog section) with honest `tier_span`, `unit_economics`,
`channel`, `warranty_reg`. Add findings: where the old identity confuses (which P-ID),
which tier it mis-signals, which S-IDs it fails. White-space/graveyard as usual; zero
fit tags.
**Do (S5A):** disposition all pairs **including self-match rows, which ship as
`(b-COMP)` or `X` — never `(a)`** (category-mode self rule; a brand cannot "swap" itself,
it can only be a component of its own future or be retired). Overclaim guardrail applies
to new promises with extra force: every new claim needs landing_place + spec cite +
named cert regime where regulated. Extend NOT-fit with old-identity boundaries
("no longer claim X", "no longer resemble P-014").
**Do (S5B):** regroup by buyer: per group mark **keep / kill / merge / split** with
reason + evidence (performance history, confusion log, refreshed stakes). Rewrite only
touched briefs; untouched briefs carry over with a carry-over note (brief count = group
count still enforced — retired groups get retirement notes, not deletions).
Then emit Blocks A+B with `carry-over` vs `new` marked per column.

**Gate:** self-as-P-ID present with honest spans; no self `(a)`; NOT-fit extended;
regroup decision per group recorded; brief=group count holds.

## Phase 4 — Brand: audit the CURRENT kit first (Stage 3 before Stage 1)

**Do:** run the Stage 3 audit instrument **on the live kit + live assets** (one
direction? competing languages? hierarchy? materials vs graphics? icon/device sprawl?
type vs positioning? pack recognizability? white space? SKU/format scalability?
source contamination?). Output KEEP / REMOVE / REFINE — then price KEEP against the
Phase-0 equity guardrails (each KEEP tagged must-keep/negotiable, each REMOVE checked
against must-keep — conflicts escalate to the user, never auto-resolved).
Classify **REFINE** (localized fixes within the live system) vs **REJECT AND RESTART**
(foundational shifts — same trigger list as `SKILL.md:457-474`, plus: audience-fit
failure per regrouped S5B, tier mis-signal per S3, confusion-with-P-ID per S4 findings).
Restart mechanics unchanged (mark rejected, keep only abstract KEEPs, never reuse the
rejected board as a reference, fresh concept + Generation Plan, never blend) — with one
addition: the rejected live system **remains the migration baseline** (old-vs-new pairs
later), it is isolated from generation but not from comparison.
Vague/conflicting feedback → Creative Director Support Mode (no generation until a
direction is chosen). Pre-Anchor bridge check (same as joint run, applied to the evolved
kit): S3 stakes re-encoded (trust weight for failure_cost groups, premium cues only where
direct_ticket earns them, livelihood-appropriate imagery); Block B expression columns
filled (wedge encoding, T6 wording tier through type/hierarchy roles, anti-patterns);
extended NOT-fit respected; gate mapping holds (NOT-fit ↔ re-Anchor, brief=group ↔
PASS-before-scale). Then **Gate 3 (re-Anchor)**: the evolved kit becomes source of
truth; locked rules + prohibitions recorded; deprecation scope (what dies, when)
entered in the checkpoint as OPEN ISSUES until shipped.

**Gate:** audit lists + equity-priced KEEP/REMOVE/REFINE + REFINE-vs-RESTART verdict +
re-Anchor explicitly approved.

## Phase 5 — Guidelines delta → key visual + migration pairs → lock/scale/pack

**Do (Stage 4):** regenerate touched guideline modules only (one 16:9 slide each,
reviewed separately); untouched modules carry over with a carry-over note. Minimum set
recomputed against new deliverables. Emphasize Do's and Don'ts with old-vs-new
examples (most-likely misapplications during transition).
**Do (Stage 5):** master key visual + SKU validation (change only approved SKU
variables; side-by-side different-brands check → audit). **Rebrand addition:** build
**migration pairs** — same scene/SKU in old vs new system — for every kept group; pairs
are the unit of probe and launch review, not single images.
**Do (Stages 6–9):** Brand Lock (scene/identity/pack roles confirmed; old-look
elements explicitly in prohibited styles), Gate 4, one test asset, audit (APPROVED
before scale), correction loop, then scale across thread matrix (Block A activation
columns, carried + new rows).
**Do (Stage 10):** packaging concepts **plus transition plan**: old/new shelf
coexistence windows, dealer/market-day sell-through order, label-zone changes sequenced
by print lead time. Conceptual-only disclaimer still applies; production needs
designers/print specialists (unchanged limitation).

**Gate:** Gate 4 roles confirmed; test asset APPROVED; migration pairs complete for
kept groups before launch approval.

## Phase 6 — Stage 11 + M0 (with old-identity probes) → M1–M4 → deprecation

**Do (Stage 11 + M0):** final review checklist + completion report, then M0 predictions
per scaled thread **plus mandatory rebrand rows**: new-vs-old recall ("which is us?"),
confusion-with-OLD rate (must fall below threshold by date), confusion-with-P-ID rate
(must not rise), tier-signal check (does the new look price correctly per S3?). Kill
conditions cover pausing launch, not just threads.
**Do (M1–M4):** instrument per-thread CTAs + both confusion probes (old identity AND
P-ID) + cost lines → collect (leading weekly, lagging per motion cycle) → judge per
PRED-ID (a FIX-BOUNDARY on old-confusion extends prohibited-styles + migration-pair
rework; persistent old-confusion after fix cycles = launch-hold, not a thread kill) →
feed back to owning artifacts only → re-gate → re-render toggles and Bonus A–D.
**Do (deprecation):** retire old assets per transition plan; close OPEN ISSUES; archive
the old Anchor as `SUPERSEDED` (kept for reference, never as a generation input —
same isolation as any rejected direction).

**Gate:** M0 rebrand rows exist with launch-hold conditions; deprecation checklist
complete; old Anchor superseded, not deleted.
