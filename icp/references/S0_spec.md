# S0 — Spec freeze

## Rule
One normative spec carries the run. Merged source dumps live in the appendix, never in the normative path. Cures S0-1 (598KB verbatim merge overwhelming the 17KB spec).

## Header (required, first lines of S0_SPEC.md)
`project | run-mode (single | category) | form (digital | physical | hybrid | human-service) | overlay (default O-GTM) | platform-role (optional) | line-cap (default 300) | K-rank (default 50) | K-fit (default 10) | model | temp | date | spec-sha | N/A until S2`

Declare `run-mode: single` for one product/service or `category` for a whole category (e.g. all CRMs, all 18V drills). Declare `form` from Q0.6 (fixes which S4 verbs are legal — software-only `b-ING/b-FACE/b-SRC` never attach to pure-physical). Declare the output `overlay` (default O-GTM; see overlays.md). Optional `platform-role: product | subsystem` records a platform's seat when relevant; omit it for non-platform subjects like soap or tractors — absent is pass, never red. Quotas may be tightened or loosened per run; undeclared quotas take defaults. `spec-sha` MUST resolve in `runs/<id>/SOURCES.log` (Q0.7 pack manifest) — dangling `spec-sha` is red (E-sources).

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
> From the attached sources (Q0.7 pack in SOURCES.log — minimum 1, recommended 5), write S0_SPEC.md in the template above plus Appendix_Raw.md for leftover source text. Declare run-mode, form and overlay; declare platform-role only when the subject sits in a platform. Stamp the header with quotas. Keep normative within line-cap.

## Inputs (expanded — the 4 shorthand terms above mean these 7 families)
1. codebase / technical (repo, manifests, APIs, schemas, infra, tickets, ADRs);
2. docs (README, wiki, manuals, datasheets, BOMs, SOPs);
3. site + product copy (landing, pricing, catalog, packaging);
4. functions/capabilities inventory (becomes RTD Level-0);
5. marketing artifacts (ads, scripts, decks, testimonials);
6. operational traces (price lists, contracts/SOWs, supplier quotes, cert filings, service logs);
7. human sources (founder interviews, call transcripts, support tickets, reviews).
Category-mode replaces 1–2 with category sources (competitor pages, comparison matrices, review sites, analyst reports, teardowns, standards).

## Format rule
Input format is irrelevant — PDF, ZIP, HTML, sheet, photo, video transcript, audio, paper scan all normalize to the same 7-section markdown. Verbatim leftovers go to Appendix_Raw.md with SHA; SOURCES.log records `S<nn> = label | family F1-F6 | path-or-url | sha | date | who | src`.

## Subject-type mapping (same template, different fill)
Digital `product/digital`: Implementation = stack/schema/APIs; Testing = fixture→Units + query precision. Physical `product/physical`: Implementation = BOM/materials/SKUs + `unit_economics/channel/warranty_reg` required; Testing = install/cert check. Hybrid: both. Human-service `service/human-service`: Implementation = SOP/work order/SLA; Testing = ticket-macro/resolution. Project: charter/phases/tickets + bootstrap order. Company/org as subject: charter/org chart/offers/channels + binding constraints. Category: envelope + wedge dims. Typical Out-of-Scope per type: digital — ranking rewrites, multi-user ACL; physical — dielines/prepress/manufacturing; service — product-swap claims; project — phase 2/3; company — media-buy, legal beyond named regime.

## Halt-and-ask
If a section cannot be filled from logged sources, halt and ask (Q0.7 swap / Q0.8 binding / Q1.4 claims) — never invent. Missing answer is red, not an assumption.

## Completion check
Out-of-Scope present, run-mode + form + overlay declared, normative within line-cap, header stamped, spec-sha resolves in SOURCES.log. Platform-role absent is pass.
