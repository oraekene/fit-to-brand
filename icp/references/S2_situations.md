# S2 — Situations

## Skeleton (fixed keys — cures scale drift S2-4)
Personal A1 Individual, A2 Pair/Dyad, A3 Friendship, A4 Couple, A5 Nuclear Family, A6 Extended Family, A7 Household, A8 Neighborhood, A9 Community, A10 Municipality, A11 Region/State, A12 Country, A13 Continental Bloc, A14 World.
Organizational B1 Solopreneur, B2 Micro (2-9), B3 Small (10-49), B4 Medium, B5 Large, B6 Corporation, B7 Multinational, B8 Team, B9 Department, B10 Religious orgs, B11 Nonprofits/NGOs, B12 Activist groups, B13 Other large social orgs (unions, associations, clubs, cooperatives, parties, schools, hospitals, military, agencies, media, leagues, standards bodies).

## Schema (S2_SITUATIONS.csv)
`S-ID (S-0001...) | level (A1/B7) | domain | sector_tags (semicolon list, may be empty; see overlays) | knowledge_need [nominal record: doses, logs, rationale — QMD style] | decision_moment [whether to... / negotiating... — AIDE style] | action_moment [embodied/physical step: apply pressure, torque to spec, transplant window — for situations where the moment is physical, not informational] | spec_link`
Lens rule: all three lens columns are present; any single lens may read `N/A: reason`, but at least one lens per row is substantive. Embodied rows (bleed control, harvest timing, torque-down) legitimately carry `N/A` on knowledge_need with a reason and substance on action_moment. One bullet per S-ID in the markdown render; comma-paragraph packing is a fail (cures uncountable AIDE P2).

## Volume rule
One file. A second volume ships only on explicit request (cures open `say "continue"` sprawl S2-3).

## Spec mapping
Every row carries `spec_link` to the S0 section it exercises (adopts QMD's Mapping Back, cures S2-5).

## Sector overlays (expandable — skeleton stays fixed)
Levels A1-B13 never change. Sector detail attaches via `sector_tags`: built-ins `SEC-HEALTH, SEC-MINING, SEC-MARITIME, SEC-AGRI, SEC-ENERGY, SEC-BUILT, SEC-INFORMAL (ROSCA, hawala, pastoralist routes, unlicensed childcare), SEC-REGULATED (OT, surgical, aviation)`. Illicit/wartime overlays ship only on explicit request. Custom overlays take the next `SEC-` key with a one-line definition in the header. A row with no sector relevance leaves the field empty — empty is pass.

## Prompt
> Using S0_SPEC.md plus theme (state which) and run-mode (state single|category), enumerate situations on skeleton A1-A14/B1-B13 with sector_tags where relevant. Emit S2_SITUATIONS.csv in the schema above with N rows plus S2_SITUATIONS.md with one bullet per S-ID. Group within each level by domain. Declare N in the header.

## Completion check
Header declares N, file holds exactly N S-ID rows, every row has a spec link and at least one substantive lens (N/A lenses carry reasons), sector_tags valid or empty, entries are bulleted.
