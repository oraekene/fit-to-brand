# S4 — Products and services

## Wording (4b wins — cures S4-1/S4-4)
List products plus services plus categories USED FOR performing each S-ID. Pure-product inventories repeat the 4a gap.

## Schema (S4_PRODUCTS.csv)
`P-ID (P-0001...) | category | type (product | service | human-service) | form (digital | physical | hybrid) | examples | tier_span | domain | S-IDs_covered | unit_economics [price band + attach/consumable rate; N/A allowed for pure digital] | channel [active overlay enum — O-GTM default: retail | dealer | distributor | direct | app-store | N/A] | warranty_reg [regime certs per active overlay — O-GTM: UL, CE, FDA, DOT; others per overlays.md; N/A allowed]`
`form` is required on every row. Physical rows require `unit_economics`, `channel` and `warranty_reg`; pure-digital rows may use N/A. Channel and cert values outside the active overlay registry are a gate fail. Physical examples: appliances, power tools, solar+battery kits, medical devices, auto parts (Takata-pattern recalls belong in findings, not as endorsements).

## Catalog sections (required — adopts QMD §§75-78, cures S4-2)
Coverage ratios, white-space (situations with no product anywhere), graveyard (dead/diminished: Reader, Pocket, Evernote-pattern), structural findings, plus own-stack-as-positions.

## Fit ban
Zero `(a)/(b)` tags in S4. Fit lives in S5A only (cures S4-5 premature collapse into triple-repeat).

## Views
Render `View-Tier` (tier order) and `View-Domain` (24-domain order) from the same CSV (cures S4-3 with no second run).

## Prompt
> For every S-ID in S2 across all tiers, list existing products, services and categories USED FOR performing it. Emit S4_PRODUCTS.csv in the schema above plus coverage, white-space, graveyard and findings. Cover every S-ID with >=1 P-ID. Write no fit tags.

## Completion check
Every S-ID maps to >=1 P-ID, every row has `form` (physical rows also have unit_economics, channel, warranty_reg), all four catalog sections exist, zero `(a)/(b)` tags appear.
