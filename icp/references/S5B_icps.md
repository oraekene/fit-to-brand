# S5B — Buyer groups and ask-briefs (GTM render: ICPs + marketing bodies)

## Rule
Briefs ship with groups. A fit table alone repeats S5-1 (both prior runs delivered zero bodies despite the filename). Core nouns are `group` and `brief`; `ICP`, `stakeholder`, `cohort`, `hooks`, `CTA`, `orders` are overlay renders per overlays.md.

## Group template (one block per GRP-ID)
`GRP-ID | grouping (buyer, command, cohort per overlay) | archetype | segment | jobs | pains | budget | buyer | channel (overlay enum) | Top S-IDs | positioning ((a) vs (b) mix) | objection | motion (overlay terms; GTM: PLG vs enterprise sales)`
Mix must span the run's real groupings. O-GTM renders GRP-ID as ICP-ID with archetypes like solo researcher, homeowner, IMF debt team, proxy board.

## Brief template (per GRP-ID)
Core: one paragraph stating the ask, three supporting points, one call. O-GTM renders it as paragraph + three hooks + CTA in the segment's wording (prosumer concrete vs board/sovereign formal); O-OPS as task + intent + constraints; O-EDU as objective + 3 checks + assignment. Segment renderings are overlay outputs, never separate runs.

## Prompt A (groups)
> Group S5A by buyer into groups in the template above using the active overlay's group nouns. Cover the full grouping span present in the tiers. State mix and motion per group in overlay terms.

## Prompt B (briefs)
> For every GRP-ID write one ask-brief in the overlay's brief format and segment wording.

## Completion check
Brief count equals group count, mix explicit, motion stated per group in overlay terms. O-GTM additionally: B2C/SMB/ENT/GOV mix explicit.
