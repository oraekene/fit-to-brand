# H2 judge prompts — deterministic invocation, judged evaluation

Fire with the cited artifact attached. Record verdicts as
`H2 <gate> <PASS|FAIL> <one-line reason>` in `runs/<id>/GATES.log`. A FAIL blocks
like any red gate; fix the stage, re-run downstream.

## J1 — S2 lens substantiveness (per S-ID row)

> For each S-ID row, judge every non-N/A lens (knowledge_need / decision_moment /
> action_moment): is it substantive (names a concrete record, decision, or physical
> step tied to the spec_link) or filler (generic "needs information", "decides well")?
> N/A lenses must carry a reason. Return per-row SUBSTANTIVE / FILLER / MISSING-REASON.
> Gate passes only if every row has ≥1 SUBSTANTIVE lens and zero MISSING-REASON.

## J2 — Theme agreement + minimality (S1)

> Judge the theme (≤3 words already H1-checked): number/agreement correct? bare noun
> only if distinctive, else Need-qualifier + Noun, never two qualifiers? Return
> PASS/FAIL with the corrected form on FAIL.

## J3 — S5A landing specificity (per fit row)

> Each landing_place must name where the capability lands in the overlay's terms (file
> path / silo / BOM / kit / shelf / work order / node / classroom / LMS — not "in the
> workflow") and each spec_module_cite must point at a real S0 section. Return per-row
> CONCRETE / VAGUE / DANGLING-CITE. Gate passes on zero VAGUE / zero DANGLING-CITE.

## J4 — S5B mix/motion explicitness (per group)

> Each group must state its positioning as an explicit (a)-vs-(b) mix, its objection
> with an answer grounded in brief points, and its motion in the overlay's terms.
> Segment wording must sit in one tier (prosumer-concrete vs enterprise-formal), never
> mixed within a brief. Return per-group EXPLICIT / VAGUE / MIXED-TIER.

## J5 — Brand consistency audit (per test asset)

> Audit against Anchor + pack ref + Brand Lock roles: logo, type family/weight/case/
> hierarchy, colors/SKU logic, device, pack shape/zones, claim accuracy, role
> compliance, prohibitions, scene contamination, brief-verbatim headline, T6 tier
> preservation, CTA hardness vs motion. Return PASS/FAIL lists + SEVERITY
> (critical/major/minor) + CORRECTION + PRESERVE + verdict
> APPROVED / CORRECTION REQUIRED / REJECT AND REGENERATE.

## J6 — Refine-vs-Reject classification
> Given the audit + user feedback, classify REFINE (localized: spacing, one color /
> material / mockup / hierarchy / detail) vs REJECT AND RESTART (any foundational
> trigger: mood, type, color logic, materials, pack architecture, hierarchy, photo
> direction, audience fit, price tier; or second failed refinement; or contradictory
> typography; or "fundamentally wrong"). On RESTART, verify isolation: rejected board
> marked, KEEPs abstract-only, no reuse as generation reference. Return the
> classification + trigger list.

## J7 — Name judgment (per NAMES.csv candidate; H1 already cleared shape + confusion)

> For each shortlist/pick candidate, judge: (1) pronounceability — sayable across a
> table, spellable over a bad phone line; (2) tier-signal — reads at the run's S3/S4
> price band, not one above or below; (3) register fit — survives both T6 tiers
> (prosumer-concrete speech and enterprise-formal print); (4) promise-check — names
> nothing S0 Out-of-Scope excludes; (5) sound/look-alike vs P-IDs beyond H1's string
> match, and vs the OLD name on renames. Return per-candidate PASS/FAIL + the failed
> criterion + a one-line reason. A FAIL removes the candidate to rejected with that
> reason (H1 enforces the reason is recorded).
