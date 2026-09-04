# Joint Audience + Positioning Bridge (icp-6 × brand-system)

Purpose: one shared contract so the two skills stop maintaining rival versions of
"who we talk to" and "why we win". Status: normative for joint runs; optional for solo runs.

Rule of ownership (do not duplicate):
- **icp-6 owns audience DEFINITION and positioning LOGIC** (countable, falsifiable,
  tied to S-IDs / P-IDs / spec cites). Source: `icp/references/S5B_icps.md`,
  `icp/references/S5A_fit.md`.
- **brand-system owns audience ACTIVATION and positioning EXPRESSION** (visual/thread
  rendering: which SKU × scene × format carries which message, and how it looks).
  Source: `brand/SKILL.md` Stages 0, 5, 6, 9 + Bonus A/B/D.
- This file is the only place both layers meet. Copy, never fork: brand imports the
  group table verbatim; icp-6 imports thread learnings back as findings.

## Correction to two common readings

1. "icp-6's audience framework is weaker than brand's." Incorrect as stated.
   icp-6 S5B is a 13-field block per GRP-ID — grouping, archetype, segment, jobs,
   pains, budget, buyer, channel (overlay enum), Top S-IDs, positioning ((a) vs (b)
   mix), objection, motion — with gates (brief count = group count, mix explicit,
   motion per group, O-GTM B2C/SMB/ENT/GOV mix). Brand Stage 0 has one line,
   `AUDIENCE:` (`SKILL.md:245`), plus Q4–Q6 free text. Analytically, icp-6 is
   stronger. What brand genuinely does better is **activation threads**: Stage 5
   key-visual system across `{{SKU_LIST}}` (8 repeatable sub-systems,
   `SKILL.md:633-641`), Stage 9 scene × SKU × format matrix with
   `{{APPROVED_VARIABLES}}` (`SKILL.md:823-839`), Bonus A recompose-not-crop +
   safe areas, Bonus B localization, Bonus D platform assets. icp-6 has no render
   matrix — only a channel label and a motion label. So: **definition lives in
   icp-6, threads live in brand.** The combined block below keeps both.
2. "One side's positioning is uniformly more advanced/creative." Incorrect framing.
   They are different types. icp-6 positioning is **competitive logic**: per-(S-ID,P-ID)
   verb (`(a)` swap / `(b-*)` wedge on price, performance, distribution,
   compatibility), `landing_place` in overlay terms + `spec_module_cite`, K-fit
   wedges, NOT-fit, overclaim guardrail with named cert regime. It is verifiable
   against the S4 catalog and S0 spec — deliberately anti-"creative" (fit ban in S4,
   single pass, no triple-map). Brand positioning is **expressive encoding**: Q5/Q6
   + creative-direction statement + Translation Opportunity rendered as
   color / type / material / hierarchy / media behavior. It is creative but has no
   incumbent, no wedge, no cite, no NOT-fit, no objection. A beautiful kit can
   still be undifferentiated. The combined block keeps **Logic (icp-6 owns) +
   Expression (brand owns)** joined on GRP-ID + verb mix + objection.

## Block A — Unified Audience (one row per GRP-ID)

Build from the icp-6 S5B row, then append the brand thread columns. Never maintain
a second audience list in the brand brief — import this table and reference it.

```text
GRP-ID | grouping | archetype | segment | jobs | pains | budget | buyer |
channel (overlay enum) | Top S-IDs | motion (overlay terms) |
--- brand-appended activation columns (filled at brand Stages 5/6/9, fed back as findings) ---
THREAD-SCENE (S-ID-grounded scene ref per group) | SKU-SUBSET | FORMATS |
HEADLINE-ZONE PROMISE (words from this group's brief, not new copy) |
PROOF-POINTS (max 3, from brief) | CTA-HARDNESS (from motion: PLG-soft … enterprise-hard) |
VISUAL-NOTES (casting/environment/material cues honoring sector_tags) | STATUS (planned/tested/scaled/killed)
```

Gates:
- Definition columns complete before brand Stage 2 (no kit without groups).
- `brief count = group count` (icp-6 gate) AND `every group has ≥1 thread row before
  Stage 9 scale` (brand-side gate). A group with no thread is explicitly `STATUS: unaddressed`,
  never silently dropped.
- Channel/motion values must belong to the active overlay registry
  (`icp/references/overlays.md`); formats must belong to the Provider Profile
  (`brand/SKILL.md` Provider Profile section).

## Block B — Unified Positioning (one row per GRP-ID, joined to Block A)

```text
GRP-ID | VERB-MIX ((a) vs (b-*) split across this group's Top S-IDs, from S5A) |
WEDGE (price | performance | distribution | compatibility + one-line evidence, category-mode) |
LANDING-PLACES (overlay-terms sentences, from S5A) | SPEC-CITES (§x.y) |
NOT-FIT-BOUNDARY (what we explicitly do not claim, from S5A NOT-fit) |
OBJECTION → ANSWER (from S5B objection + brief points) | CERT/SAFETY NOTE (named regime or N/A) |
--- brand-appended expression columns ---
VISUAL-ENCODING (how the wedge reads: e.g. compatibility → side-by-side SKU lineup + label-zone lockup) |
TYPOGRAPHY/HIERARCHY ROLE (which S5B wording tier: prosumer-concrete vs formal) |
ANTI-PATTERNS (visual must-not-resemble list: P-IDs + rejected directions) | STATUS
```

Gates:
- Logic columns complete before brand Stage 2; expression columns locked at Anchor
  approval and frozen by Brand Lock roles thereafter.
- Brand **must not invent** wedge, claim, or cert to fill a layout (brand `Never Invent`
  + icp-6 honesty gate both apply). New copy needed → `GO BACK` to S5B, not a layout fix.
- Category-mode self-match rows stay `(b-COMP)`/`X`, never `(a)`
  (`icp/references/S5A_fit.md:15`); the visual system must show ingredient/add-on
  language there, not full-swap hero language.

## Minimal worked example (shape, not content)

- `GRP-03 | buyer: facilities leads, SMB | segment: SMB | Top S-IDs: S-0041,S-0087 |
  motion: PLG | objection: "looks like P-0014"` (icp-6 S5B row).
- Logic: verb-mix `(b-ACC)` on S-0041/P-0014 (consumable add-on), wedge = compatibility
  + landing_place "shelf-side clip-strip next to P-0014, §3.2" (S5A row).
- Activation: thread-scene = S-0041 action_moment (storeroom restock), SKU-subset = 2 SKUs,
  formats = 4:5 shelf + 16:9 web; headline = S5B hook verbatim; proof = 2 brief points;
  visual-notes = match `SEC-BUILT` lighting/materials, must-not-resemble P-0014 pack architecture.
- Measurement (see `MEASUREMENT-LOOP.md`): CTR/meeting-rate per GRP-03 thread vs brief
  prediction; confusion-with-P-0014 rate → feeds NOT-fit / prohibited-styles.

## Wiring (tiny hooks, no pipeline rewrites)

- Joint run: icp-6 S5B emits Block A definition columns + Block B logic columns as
  `S5B_GROUPS.csv` annex. Brand Stage 0 imports that CSV into the brief (replaces the
  single `AUDIENCE:` line with a table reference) and appends activation/expression
  columns at Stages 5/6/9.
- Solo icp-6 run: leave brand columns empty (`STATUS: unaddressed`) — still valid.
- Solo brand run: fill definition columns by hand but mark `EVIDENCE: unvalidated`
  until an S5A/S5B pass exists; do not present hand-filled wedges as validated fit.
- Feedback: thread/audit learnings return as icp-6 S4 findings + S5A NOT-fit reasons
  and brand prohibited-styles — never as silent edits to locked logic columns.
