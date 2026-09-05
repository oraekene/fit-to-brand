# hooks/ — gate enforcement (deterministic triggering for all, deterministic evaluation where possible)

Direct answer to "can all gates be hooks?": **all gates can be *triggered*
deterministically** (every stage transition invokes the hook runner, which blocks on
red). But only a subset can be *evaluated* deterministically. Three tiers plus the
runner that binds them:

- **Runner (`ftb.ps1`) — the choke point.** Phases advance only via `ftb next`
  (`init` / `next` / `ask` / `status`; `-RunId`, `-Variant Joint|Rebrand|Campaign`).
  `next` runs the exit-lock (Validate-Gates stages mapped to the closing phase) then
  the entry-lock for the next phase (Enter-Phase); both green → STATE.json advances
  and the next ask-list prints. The agent's only transition rule: never work a phase
  STATE.json doesn't name. Verified: full 0→10 walk with locks firing at every step.
- **H1 — deterministic validators** (`Validate-Gates.ps1`). Pure functions over run
  artifacts: counts, ID shapes, enum membership, regex bans, presence checks, file
  existence. Exit 0 = pass, non-zero = red, blocks the transition. No LLM, no human.
- **H2 — judge prompts** (below). Substance/quality calls an LLM-as-judge makes with
  the cited rubric: lens substantiveness, landing-place specificity, positioning-mix
  explicitness, theme agreement, audit rubric, refine-vs-reject classification. The
  *invocation* is deterministic (runner fires the prompt with the artifact attached);
  the verdict is recorded as `H2 <gate> <PASS|FAIL> <reason>` in `GATES.log`.
- **H3 — human approvals** (the 4 brand gates, Anchor, Generation-Plan spend approval,
  launch-hold). Recorded as `H3 <gate> APPROVED <date> <by>` in the run's `GATES.log`.
  H1 verifies the *existence* of the token before the next stage — a missing approval
  is a deterministic red; the approval itself stays human.

## Gate→hook matrix (every gate in the combined repo)

### icp/ gates (`icp/references/gates.md`)

| Gate | Check | Tier | Hook |
|---|---|---|---|
| G1 header | required header fields present; quotas defaulted, never silently mixed | H1 | `Test-Header` |
| G2 count | header N = S2 rows = S3 rows = S4 S-ID coverage = S5A coverage | H1 | `Test-Counts` |
| G3 IDs | `S-0001`/`P-0001` shape, unique, sequential; fit rows reference existing IDs; sector_tags empty or `SEC-KEY` shape (custom-key one-line definitions → H2) | H1 | `Test-Ids` |
| G4 grammar | theme ≤3 words | H1 | `Test-ThemeWords`; number-agreement → H2 prompt |
| G5 S2 format | bulleted companion, one bullet per S-ID | H1 | `Test-S2Bullets`; lens substantiveness → H2 |
| G5 S2 lenses | every row ≥1 substantive lens; N/A lenses carry reasons | H1 presence + H2 substance | `Test-S2Lenses` + judge |
| G5 S3 $0 | every $0 has `priceless_flag` or `no_direct_ticket`+reason; subsistence rows have livelihood tier + note | H1 | `Test-S3Zero` |
| G5 S4 fit-ban | zero `(a)/(b)` tags in S4 | H1 (regex) | `Test-S4FitBan` |
| G5 S4 physical | physical rows have unit_economics + channel + warranty_reg; channel/certs in overlay registry | H1 | `Test-S4Physical` |
| G5 verb legality | software-only verbs never on pure-physical P-IDs; category self-match never `(a)` | H1 | `Test-VerbLegality` |
| G5 S5A rows | every row has landing_place + spec cite | H1 presence + H2 specificity | `Test-S5ARows` + judge |
| G5 S5B | brief count = group count; group nouns in overlay registry; mix + motion explicit | H1 counts/registry + H2 explicitness | `Test-S5B` + judge |
| G6 honesty | Out-of-Scope non-empty; NOT-fit non-empty or justified; safety note where required | H1 presence | `Test-Honesty` (correctness → H2) |
| G7 redundancy | no triple-mapped category; one S2 file (second volume only on request) | H1 | `Test-Redundancy` |

### brand/ gates (`brand/SKILL.md`)

| Gate | Check | Tier | Hook |
|---|---|---|---|
| Gate 1 brief | approval recorded before reference analysis | H3 (`GATES.log`), existence H1 | `Test-Approval -Gate Gate1` |
| Gate 2 direction | approval recorded before any kit generation | H3, existence H1 | `Test-Approval -Gate Gate2` |
| Generation Plan | all required fields present (profile, cost, fonts+source, prohibitions, formats, workaround) | H1 fields + H3 spend approval | `Test-GenPlan` + approval token |
| Gate 3 Anchor | approval recorded; locked rules + prohibitions in checkpoint | H3, existence H1 | `Test-Approval -Gate Gate3` |
| Guideline modules | one output per declared module; reviewed separately | H1 (file count = modules) | `Test-Modules` (pixels unverifiable — noted limit) |
| Typography | exact family + source + role recorded; visible labels claimed | H1 record check (render match needs vision → H2/human note) | `Test-TypeRecord` |
| Gate 4 Brand Lock | roles confirmed + one test asset + audit verdict | H3 roles + H1 (asset exists, verdict token) | `Test-Approval -Gate Gate4`, `Test-AuditVerdict` |
| Audit | verdict ∈ {APPROVED, CORRECTION REQUIRED, REJECT AND REGENERATE}; scale only on APPROVED | H1 token + H2 rubric quality | `Test-AuditVerdict` + judge |
| Refine-vs-Reject | classification follows the trigger lists; restart isolation honored | H2 prompt | judge |
| Stage 11 review | checklist + M0 predictions per scaled thread | H2 checklist + H1 `Test-M0Coverage` | mixed |
| Bonus E M0 | every scaled thread has prediction + kill + reposition conditions | H1 | `Test-M0Coverage` |

### bridge/ gates (contracts + orchestrations)

| Gate | Check | Tier | Hook |
|---|---|---|---|
| One audience list | brief imports S5B table (no second list) | H1 (import marker) + H2 | `Test-NoFork` |
| Block A/B completeness | required columns present and non-empty per row | H1 CSV schema | `Test-Blocks` |
| Thread-per-group | every non-retired group has ≥1 thread row or explicit `unaddressed` | H1 | `Test-Threads` |
| Wiring marks | carry-over/new, unaddressed, EVIDENCE values from closed enum | H1 | `Test-Blocks` |
| M-file chain | M0→M1→M2→M3 present in order before M4 writes | H1 existence | `Test-MChain` |
| N naming screen | candidates have route + status; rejections reasoned; caps hold; shortlist H1-clean | H1 | `Validate-Naming.ps1 -Stage screen` (ftb phase-4 exit) |
| N naming lock | exactly one pick; pick H1-clean; TM/domain/handle confirmed | H1 presence | `Validate-Naming.ps1 -Stage lock` (ftb phase-6 exit) |
| J7 name judgment | pronounceability, tier-signal, register, promise-check, sound-alikes | H2 prompt | judge |

## Trigger points (when the runner fires)

| Transition | Fire |
|---|---|
| Leaving S0 / S1 | `Test-Header`, honesty (S0), theme words |
| Leaving S2 / S3 | counts, IDs, bullets, lenses, $0 flags |
| Leaving S4 / S5A | counts, IDs, fit-ban, physical, verb legality, rows, NOT-fit |
| Leaving S5B | counts, S5B, honesty; emit Blocks |
| Brand Gate 1–4, Generation Plan, scale, launch | approvals, gen-plan, audit verdict, modules, M0 coverage |
| M-transitions | M-chain, thread coverage |

Wire into whatever runner you use (agent pre-transition checklist, CI on `runs/`, or
manual `./hooks/Validate-Gates.ps1 -RunDir runs/<id> -Stage <stage>`). H2 prompts live
in `JUDGE-PROMPTS.md`; H3 log format: one line per approval,
`H3 <gate> APPROVED <yyyy-mm-dd> <who>`.

## Elicitation (ASK spine — the anti-silent-run hook)

Full Q-sets: `bridge/QUESTIONNAIRES.md`; per-orchestration timing tables sit atop each
orchestration. Agent fires Q-sets via the question tool (≤3 per exchange, recommended
first, explicit defaults); answers land in `runs/<id>/PARAMS.log` as
`Q<id> = <value> | <date> | <who>` plus write-through to the owning artifact.
`Test-Params` blocks the transition when required keys are missing: S0 needs
Q0.0–Q0.8 + Q1.1–Q1.4 + QN.0; S5B needs Q5.1; BRAND needs Q10.1; M needs Q13.1 + QRP.1.
`Test-Sources` (E-sources, S0 exit-lock) blocks when `SOURCES.log` is missing, has
zero `S<nn> =` lines, carries a bad family tag, or the S0 `spec-sha` does not resolve
in the manifest.
QN.3 (name pick) is required at phase-6 entry when S0 declares naming required.
A phase that exits on assumptions instead of answers is red, same as any gate.

Deterministic triggering: `Test-Params` is the *exit lock* (detects missing answers
after the fact). `Enter-Phase.ps1 -RunDir runs/<id> -Phase N [-Variant Joint|Rebrand|
Campaign]` is the *entry lock + ask emitter*: it asserts all prior-phase keys and
prints the exact Q-set to ask now (exit 1 names the missing questions). Same inputs →
same ask-list, same code, every time. In practice drive both through `ftb.ps1 next`
(see Runner above) rather than invoking them separately.
Enforcement beyond this repo: `platforms/` (per-agent adapters incl. Claude Code
blocking guard) + `.github/workflows/fit-to-brand-gates.yml` (CI bouncer — bad run
states cannot land on main). The remaining non-deterministic step is the
agent actually invoking the runner each phase — that is one rule instead of dozens,
and CI catches violations at land time.

## Hook-layer file conventions (run artifacts the H1 validators read)

`runs/<id>/icp/S0_SPEC.md`, `S2_SITUATIONS.csv/.md`, `S3_STAKES.csv`, `S4_PRODUCTS.csv`,
`S5A_FIT.csv`, `S5B_GROUPS.csv` (with `GRP-ID` + non-empty `BRIEF` columns),
`NOTFIT.md`; `runs/<id>/bridge/THREADS.csv` (`GRP-ID`, `STATUS`), `M_PREDICTIONS.csv`
(`PRED-ID`, `GRP-ID`, `KILL_CONDITION`, `REPOSITION_CONDITION`); `runs/<id>/GATES.log`;
`runs/<id>/PARAMS.log` (`Q<id> = <value> | <date> | <who> | src=<asked|batch|batch-deferred|default>` per `bridge/QUESTIONNAIRES.md`);
`runs/<id>/SOURCES.log` (`S<nn> = <label> | <family F1-F6> | <path-or-url> | <sha-or-n/a> | <date> | <who> | src=<asked|dropped|batch|default>` per Q0.7).
Headers follow the skill schemas (`icp/references/S2_situations.md` etc.).
