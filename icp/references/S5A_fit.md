# S5A — Fit

## Verb set (QMD six win over binary — cures S5-3; physical verbs added v1.2)
Digital: `(a)` complete replacement | `(b-ING)` ingest/export into corpus | `(b-FACE)` query-face grounding | `(b-SRC)` source connector | `(b-COMP)` in-pipeline component or subassembly | `(b-SURV)` surveillance/monitor | `X` no-fit with reason.
Physical: `(b-ACC)` accessory, consumable or add-on | `(b-DIST)` bundle, kit or distribution pairing | `(b-SERV)` install, maintenance or warranty wrapper. `(a)` and `(b-COMP)` span both worlds (full-SKU swap vs subassembly inside the BOM). Software-only verbs (`b-ING/b-FACE/b-SRC`) never attach to a pure-physical P-ID — pick the physical verb or `X`.

## Schema (S5A_FIT.csv)
`S-ID | P-ID | verb | landing_place [one sentence naming where the capability lands in the overlay's terms: GTM file path / silo / export, hardware BOM / kit / shelf / work order / service call, OPS node / depot / tasking, EDU classroom / LMS / assignment] | spec_module_cite [§x.y engine or hardware spec section]`
Concrete landing-place plus spec cite are both required (keeps QMD concreteness and AIDE depth — cures S5-5).

## Required blocks
NOT-fit list with reasons, K-fit recurring insertion points, K-fit replacements. Single pass only; mapping the same categories three times is a fail (cures S5-4 redundancy).

## Run-mode rule (category-mode)
In `single` mode `(a)` means full swap of the named incumbent. In `category` mode (S0 declares the whole category) `(a)` means share-shift from the named incumbent with a stated wedge (price, performance, distribution, compatibility); self-match rows (category vs itself) ship as `(b-COMP)` or `X`, never `(a)`. K-fit lists rank wedges, not swaps, in category-mode.

## Overclaim guardrail
State the honest boundary alongside the win: regulated, safety-critical and civic-core targets ship as `X` or a narrowly scoped `b-` with a safety note naming the required certification's regime per the active overlay (O-GTM: UL, CE, FDA, DOT; OPS: ROE/LOAC/medical-ordnance; EDU: curriculum standards) and the adjacent seat the project does occupy.

## Prompt
> Read S0 (note run-mode and overlay) plus S2/S3/S4. For every (S-ID, P-ID) emit S5A_FIT.csv in the schema above. Add NOT-fit, K-fit insertion points and K-fit replacements (wedges in category-mode). Single pass. Enforce the overclaim guardrail.

## Completion check
Every P-ID dispositioned, every row has landing-place plus spec cite in the overlay's terms, NOT-fit non-empty or explicitly justified, no triple-mapped category.
