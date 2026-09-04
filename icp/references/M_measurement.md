# M — Joint measurement loop M0–M4 (post-S5B, normative for runs that reach market)

Full spec: `bridge/MEASUREMENT-LOOP.md` (shared with brand-system). This file is the
icp-6-side hook; S0–S5B gates are unchanged.

## When it runs
After S5B completes. M0 predictions are written jointly with brand Stage 11; M1–M3 run
in market; M4 writes back into icp-6 artifacts per the address table below.

## icp-6-side outputs (joint runs)
- `S5B_GROUPS.csv` annex carrying Block A definition columns + Block B logic columns
  (see `bridge/AUDIENCE-POSITIONING-BRIDGE.md`). Brand imports it verbatim.
- `M_PREDICTIONS.csv` rows per `(GRP-ID × thread)` with kill + reposition conditions (M0).
  No prediction → thread does not scale.

## M4 write-back addresses (icp-6-owned only)
- Stakes miscalibration → S3 `price_note` + anchor_source append (re-gate: $0/flag/currency rules).
- Verb/wedge wrong → S5A verb or wedge rewrite + new landing_place/spec cite; old row kept
  as superseded (re-gate: landing+cite, NOT-fit, single-pass, no triple-map).
- Brief/objection wrong → S5B brief rewrite for that GRP-ID only; brief count = group count
  preserved; dead groups retired by note, never deleted (count gate preserved).
- Visual confusion with a P-ID → S4 findings + S5A NOT-fit reason (feeds brand
  prohibited-styles in return).
- Anchor deviations that outperformed → NOT written here; they go through brand `GO BACK`
  and return as S5B brief proof-points only after re-approval.

## Lightweight pre-launch variant
5-person confusion/recall probes per thread + production-cost actuals. Same schemas,
`SAMPLE-NEEDED: 5`, lagging metric `N/A: pre-launch`. A probe failure on the
must-not-resemble P-ID blocks scale exactly like a market kill-condition trip.

## Prompt
> With S5B complete, emit the S5B_GROUPS.csv annex (Blocks A+B definition/logic columns)
> plus M_PREDICTIONS.csv with one falsifiable row per scaled (GRP-ID × thread), each with
> kill and reposition conditions, owner, and date. Threads without predictions are marked
> STATUS: unaddressed and do not scale.

## Completion check
Annex columns match Blocks A+B; every scaled thread has a prediction row with kill +
reposition conditions; solo runs without threads are explicitly marked unaddressed.
