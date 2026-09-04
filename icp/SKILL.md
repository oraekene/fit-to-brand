---
name: icp-6
description: Contested-fit pipeline mapping any capability onto situations, incumbents, fit and buyer groups. Use when user wants target markets or ideal customer profiles from a spec. Use when user wants fit mapping outside markets such as missions, lessons or roles. Use when user wants to resume a run from S0/S1/S2/S3/S4/S5 artifacts. Use when user wants alternate views such as direct-ticket vs failure-cost or tier vs domain.
---

# ICP-6 v1.4 — contested-fit mapping (GTM overlay default)

Run stages S0 through S5B in order. Never skip a gate. Every stage writes its artifact before the next starts. The core is market-agnostic; market wording (`ICP`, ad bodies, ACV, PLG) is the default O-GTM render, not the core.

Leading words: **fit** (core), **icp** (GTM overlay default). Every artifact, ID, and gate uses them: an `S-ID` is one fit situation, a `P-ID` one incumbent product, fit is always `(S-ID, P-ID)`.

## Steps

### 0. Freeze the spec
Produce `S0_SPEC.md` (normative, within line-cap default 300: Problem / Solution / User Stories / Implementation / Testing / Out-of-Scope / Notes) plus `Appendix_Raw.md` for any merged source dumps. Declare `run-mode: single|category` and `overlay` (default O-GTM); declare `platform-role` only when the subject sits in a platform (omit for soap, tractors, haircuts). Stamp the header with quotas.
For the template and merge rule see [S0 reference](references/S0_spec.md).
Done when: Out-of-Scope exists, run-mode and overlay are declared, normative body is within line-cap, header is stamped.

### 1. Distill the theme
Run RTD Levels 0-6 and save the worksheet. Keep both `theme_broad` and `theme_sharp` on a fork; tag every downstream run with which one it uses.
For the ladder, battery, worksheet and grammar gate see [S1 reference](references/S1_theme.md).
Done when: worksheet plus Distinctiveness / Reconstruction / Portability / Collapse / Minimality table is saved, theme is grammatical and <=3 words, fork is recorded.

### 2. Enumerate situations
Enumerate every situation on the fixed A1-A14 + B1-B13 skeleton with sector_tags where relevant, one row per `S-ID` with `knowledge_need`, `decision_moment` and `action_moment` (any one lens may be N/A with a reason; at least one substantive) plus `spec_link`. Render the countable markdown companion. Cap at one file; a second volume needs an explicit request.
For keys, schema, overlays, prompt and volume rule see [S2 reference](references/S2_situations.md).
Done when: header declares `N`, file holds exactly N `S-ID` rows, every row has a spec link and at least one substantive lens, sector_tags valid or empty, entries are bulleted (comma-paragraphs absent).

### 3. Rank stakes
Score every S-ID on both lenses in one CSV with base currency/year/PPP source plus price_note caveats, then derive the views (decade rank K-rank, narrative tiers, amplifier, forced linear Top-K, livelihood re-score).
For definitions, tier systems, multipliers and views see [S3 reference](references/S3_stakes.md).
Done when: row count equals N from S2, every `$0` carries `priceless_flag` or `no_direct_ticket` with a reason, year and currency are stated, anchors have sources.

### 4. Map incumbents and services
List products plus services plus categories USED FOR performing each S-ID (4b wording). Channel and cert values come from the active overlay registry (GTM default). Add coverage ratios, white-space, graveyard and findings. Never write `(a)/(b)` fit here.
For the 4b prompt, schema and catalog sections see [S4 reference](references/S4_products.md).
Done when: every S-ID maps to >=1 `P-ID`, channel/certs belong to the active overlay, coverage / white-space / graveyard / findings all exist, zero `(a)/(b)` tags appear.

### 5A. Fit every incumbent
Disposition every `(S-ID, P-ID)` with the fit verbs plus landing-place plus spec cite, honoring run-mode (`(a)` = swap in single mode, share-shift with wedge in category mode). Name any required certification's regime per the active overlay. Record NOT-fit, the K-fit insertion points and K-fit replacements/wedges in one pass.
For the verb set, schema and overclaim guardrail see [S5A reference](references/S5A_fit.md).
Done when: every P-ID is dispositioned, every row has a landing-place and a spec cite, NOT-fit is non-empty or explicitly justified as empty, no category is mapped three times.

### 5B. Cut buyer groups and ask-briefs
Group S5A by buyer into groups with budget, buyer, channel and motion, then write one ask-brief per group. The GTM overlay renders groups as ICPs and briefs as paragraph + three hooks + CTA; other overlays render per [overlays](references/overlays.md).
For the group template and brief prompts see [S5B reference](references/S5B_icps.md).
Done when: brief count equals group count, segment mix is explicit, motion is stated per group in the overlay's terms.

## Cross-stage rules
Load [gates and reconciliation](references/gates.md) before starting any stage and enforce it at every gate. Load [toggles](references/toggles.md) when rendering alternate views rather than re-running. Load [output overlays](references/overlays.md) for channel, cert, group-noun and brief-format registries. Load [failure modes](references/failure_modes.md) when a gate goes red. After S5B, load [measurement loop](references/M_measurement.md) for M0–M4 on runs that reach market (full spec in `bridge/MEASUREMENT-LOOP.md`; audience/positioning join contract in `bridge/AUDIENCE-POSITIONING-BRIDGE.md`). Match stage voice to [paired examples](references/examples.md) (record vs choice, direct vs failure, concrete landing-place plus spec cite).
