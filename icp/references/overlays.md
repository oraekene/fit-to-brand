# Output overlays — one core, many renders (v1.4)

The core pipeline maps contested fit: capability × situations × incumbents × buyer-groups + ask-briefs. Market language is one render, not the core.

## Registry
Active overlay is declared in the S0 header (`overlay: O-GTM | O-OPS | O-EDU | O-SUBSISTENCE | O-<custom>`). Custom overlays take the next `O-` key with a one-line definition plus its channel enum, cert regime, group noun and brief format. Channels, certs and group nouns must belong to the active overlay's registry — cross-overlay terms are a gate fail.

## O-GTM (default) — markets
Groups render as ICPs. Briefs render as one paragraph + three hooks + CTA. Channels: retail | dealer | distributor | direct | app-store. Certs: UL, CE, FDA, DOT. Motion: PLG vs enterprise sales. `(a)` = swap (single) / share-shift with wedge (category).

## O-OPS — operations
Groups render as stakeholders (command, unit, cell). Briefs render as orders (task + intent + constraints). Channels: supply nodes, depots, field stations. Certs: ROE, LOAC, medical/ordnance regimes — name the regime. Motion: directive vs request.

## O-EDU — learning
Groups render as cohorts (class, tier, track). Briefs render as lesson briefs (objective + 3 checks + assignment). Channels: classroom, LMS, field. Certs: curriculum standards — name the standard. Motion: required vs elective.

## O-SUBSISTENCE — non-monetized economies
Prices render as staple-equivalents with PPP note; decade bands pair with livelihood tiers, never stand alone. Channels: market-day, co-op, barter, depot. Certs: customary/elders regimes where applicable.

## Quotas (parameterized, not hard-coded)
`line-cap` (default 300, S0 normative), `K-rank` (default 50, S3 forced-linear view), `K-fit` (default 10, S5A insertion points + replacements/wedges). Declared in the S0 header; any run may tighten or loosen them, but a run that silently uses two values is red.
