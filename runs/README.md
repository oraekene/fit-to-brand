# runs/ — per-run workspaces (git-ignored)

One folder per run: `runs/<run-id>/` with `icp/` (S0_SPEC.md … S5B artifacts),
`brand/` (brief → deliverables + checkpoint), `bridge/` (Blocks A+B tables,
M0_BASELINE.md, M_PREDICTIONS.csv, M1_INSTRUMENT.md, M2_OBS.csv, M3_DECISIONS.md),
and `GATES.log` (H3 approval record — H1 hooks verify its entries exist).

Naming inside a run: `S-0001`, `P-0001`, `GRP-ID`, `PRED-ID`, `<run-id>-M*.csv`.
Run artifacts are ignored by git (see `.gitignore` here) — the repo holds the
system, not your market data.
