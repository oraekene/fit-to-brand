# NAMING — advanced name pipeline (new offerings + renames)

Names are positioning made pronounceable. This pipeline derives candidates from the
joint run's own analytics instead of brainstorming in a vacuum: theme constrains
meaning, stakes constrain tier-signal, segments constrain register, incumbents
constrain confusion, Out-of-Scope constrains promises. A name that passes all five
is rare; the pipeline is built to reject fast, not to fall in love early.

Applies to joint runs (new product/project/service) and to rebrands that include a
rename (see Rename variant). Campaign runs never name — the name is locked input.
S0 declares `naming: required` (default) or `naming: n/a: reason` (fixed legal names,
campaign-only work). H1 enforces via `hooks/Validate-Naming.ps1` when required.

## Pipeline N0–N5

### N0 — Working title (S0, provisional, always)

QN.0 records a working title (often the S0 project name) marked PROVISIONAL. It
exists so artifacts have a handle; nothing downstream may treat it as decided.

### N1 — Criteria derivation (after S1 + S3 + S5B; QN.1 ranks them)

Derive, don't invent — one criterion per source:

- **Theme fit (S1):** the name must point at `theme_sharp`, never broader. A name that
  fits the broad theme but misses the sharp one describes the category, not the win.
- **Tier-signal (S3 + S4 `tier_span`):** the name must read at the run's real price
  band. Budget-reading names on mid-tier offers (and reverse) fail here, before any
  design money is spent.
- **Register fit (S5B, T6):** the name must survive both wording tiers —
  prosumer-concrete speech and enterprise-formal print. Unpronounceable spellings die
  here.
- **Confusion screen (S4 P-IDs + examples):** the name must not read as any incumbent.
  Deterministic part runs in H1 (normalized containment + token overlap); judgment
  part in H2 (sound-alike, look-alike).
- **Promise check (S0 Out-of-Scope):** the name must not promise excluded scope. A
  cooling-adjacent name on a 200W hub is an X-row wearing a wordmark.

QN.1 asks the user to rank tier-signal vs distinctiveness vs descriptiveness — the
rank breaks ties at shortlist, deterministically.

### N2 — Generation (routes, not brainstorms)

Generate 8–15 candidates across routes (no route quotas — use the count you have):

- **descriptive** (says what it does), **evocative** (says how it feels),
  **coined** (built morphemes), **compound** (two real words fused).
- Hard caps (H1): ≤4 words, ≤32 chars. Spoken-voice test from the start: sayable
  across a table, spellable over a bad phone line.

### N3 — Screens (H1 deterministic + H2 judge + manual human)

- **H1** (`Validate-Naming.ps1 -Stage screen`): columns present, routes/STATUSES from
  closed enums, rejected rows carry REJECT_REASON, length caps hold, shortlist + pick
  rows H1-confusion-clean vs S4 examples corpus.
- **H2** (judge J7): pronounceability, tier-signal calibration, T6 register fit,
  cross-language red flags, promise-check vs Out-of-Scope, sound/look-alike vs P-IDs
  and (rebrand) vs OLD name.
- **Manual (human, QN.4 confirm — the agent cannot do these):** trademark search,
  domain availability, handle availability. Each recorded `ok` or `waived: reason` in
  NAMES.csv. Unguessed, unskipped.

### N4 — Shortlist + pick (3–5 survive; human picks, QN.3)

Present the shortlist with route + screens + tier-read + the QN.1 rank applied, so
the pick is a decision, not a vibe. Exactly one pick at lock.

### N5 — Lock (before brand Stage 2 kit; blocks phase-6 entry)

`Validate-Naming.ps1 -Stage lock`: exactly one pick, pick H1-clean, manual columns
filled. The pick feeds the wordmark (Stage 2 typography: custom lettering vs font
roles hinge on it) and Gate 3's locked rules. A kit built on an unlocked name is
rework waiting to happen — the hook says so with an exit code.

## Rename variant (rebrand with a new name)

- **Verdict first (parallel to S1 keep/evolve/replace):** keep / evolve (qualifier
  shift) / replace, priced against name equity (recognition, contracts, shelf
  presence) — QR.1 covers assets; the name gets its own line because names carry
  legal and search equity assets don't.
- **OLD name joins the confusion corpus:** the rebrand's S4 self-as-P-ID row carries
  the old name in examples, so H1 screens the new candidates against it automatically.
- **Migration:** old→new mapping, coexistence window (QR.3), and the M0
  confusion-with-OLD probe (PRED rows already required by `REBRAND-ORCHESTRATION.md`)
  doubles as the rename acceptance test.
- **SunJar illustration note:** the fictional rebrand kept its name (identity-only
  change) — the rename path not taken, recorded explicitly rather than assumed.

## Artifact + hooks

- `runs/<id>/bridge/NAMES.csv`: `CANDIDATE | ROUTE | TIER_READ | STATUS
  (candidate|shortlist|pick|rejected) | REJECT_REASON | MANUAL_TM | MANUAL_DOMAIN |
  MANUAL_HANDLE`.
- H1: `hooks/Validate-Naming.ps1 -RunDir <dir> [-Stage screen|lock]`; wired into
  `ftb.ps1` phase-4 exit (screen) and phase-6 exit (lock); skips green when S0 says
  `n/a` or no S0 exists yet.
- H2: judge J7 in `hooks/JUDGE-PROMPTS.md`.
- Elicitation: QN.0 (S0 keys), QN.1 (criteria rank, phase 4–5), QN.3 (pick — required
  at phase-6 entry when naming required), QN.4 (manual confirms).
- Miniature: `bridge/illustrations/data-joint/bridge/NAMES.csv` (SunJar pick story,
  incl. a confusion rejection); CI asserts screen + lock green.
