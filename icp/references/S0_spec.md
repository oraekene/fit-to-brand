# S0 — Spec freeze

## Rule
One normative spec carries the run. Merged source dumps live in the appendix, never in the normative path. Cures S0-1 (598KB verbatim merge overwhelming the 17KB spec).

## Header (required, first lines of S0_SPEC.md)
`project | run-mode (single | category) | overlay (default O-GTM) | platform-role (optional) | line-cap (default 300) | K-rank (default 50) | K-fit (default 10) | model | temp | date | spec-sha | N/A until S2`

Declare `run-mode: single` for one product/service or `category` for a whole category (e.g. all CRMs, all 18V drills). Declare the output `overlay` (default O-GTM; see overlays.md). Optional `platform-role: product | subsystem` records a platform's seat when relevant; omit it for non-platform subjects like soap or tractors — absent is pass, never red. Quotas may be tightened or loosened per run; undeclared quotas take defaults.

## Template
1. Problem Statement
2. Solution
3. User Stories (numbered)
4. Implementation Decisions
5. Testing Decisions (with acceptance test)
6. Out-of-Scope (required — empty is a fail)
7. Further Notes (ADRs, risks, bootstrap order)

Keep the normative body within line-cap (default 300). Move version histories, precedence ledgers and verbatim texts to `Appendix_Raw.md` with a SHA manifest per source.

## Acceptance test example
Name one runnable query (e.g. known personal-decision query returns own-notes Units in top five; 50-unit batch searchable in under five minutes). The test stays runnable on demand.

## Prompt
> From the attached codebase, docs, site copy and marketing artifacts (or category sources in category-mode), write S0_SPEC.md in the template above plus Appendix_Raw.md for leftover source text. Declare run-mode and overlay; declare platform-role only when the subject sits in a platform. Stamp the header with quotas. Keep normative within line-cap.

## Completion check
Out-of-Scope present, run-mode and overlay declared, normative within line-cap, header stamped. Platform-role absent is pass.
