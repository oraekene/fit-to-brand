# S3 — Stakes

## Definitions (state both up front — cures S3-1 drift)
- `direct_ticket` — typical value moved by the decision itself, excluding downstream (AIDE lens, for pricing/GTM).
- `failure_cost` — `max(single-event, annualized)` cost when the knowledge is missing, wrong or undiscoverable at the moment of need, times multipliers: irreversibility, litigation 2-10x, regulatory, life-safety, tail, bleed, compounding (QMD lens, for risk/compliance).
- Currency rule: header declares base currency + year + PPP source (default USD + year). Bands stay in base currency for comparability; `price_note` carries PPP adjustment, subsistence/non-monetized caveats and barter equivalents. Subsistence rows never force-fit a decade band silently — pair the band with a livelihood tier and note. Every anchor needs a source.

## Schema (S3_STAKES.csv, one row per S-ID)
`S-ID | direct_ticket_typical_USD | failure_cost_max_USD | tier_decade (T1 $1T+, T2 $100B-1T, T3 $10-100B, T4 $1-10B, T5 $100M-1B, T6 $10-100M, T7 $1-10M, T8 $100K-1M, T9 $10K-100K, T10 $1K-10K, T11 $100-1K, T13 $0) | tier_narrative (T0 systemic $10B+, T1 corporate $100M-10B, T2 institutional $10M-100M, T3 life-changing $1M-10M, T4 household $100K-1M, T5 serious $10K-100K, T6 bounded $1K-10K, T7 nominal <$1K, T8 $0/priceless, plus L1-L4 livelihood) | priceless_flag | price_note (PPP/subsistence caveat, empty allowed) | anchor_source`
Both tier columns ship together (cures S3-2). One CSV replaces narrative-plus-flat-list dual formats (cures S3-3).

## $0 rule (cures S3-4)
`$0` ships only with `priceless_flag` (sacred: grief, oral history) or `no_direct_ticket` with a reason (procedural: scope negotiation). Elections, peace treaties and courts never ship as silent $0.

## Views (derive, never re-run)
Decade rank 1-N, narrative tiers, amplifier table (same S-ID across holders), forced linear Top-50, livelihood re-score.

## Prompt
> Rank every S-ID in S2 on both lenses. Emit S3_STAKES.csv in the schema above with row count = N. State both definitions, base currency/year/PPP source, multipliers and the $0 rule in the header.

## Completion check
Row count equals N, every $0 is flagged with a reason, base currency/year/PPP source stated, subsistence rows carry livelihood tier + note, anchors sourced.
