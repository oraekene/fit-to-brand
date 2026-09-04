# fit-to-brand — contested fit → brand system → market loop

One repo, three layers: **decide who to talk to and why you win** (`icp/`),
**express it as a consistent visual system** (`brand/`), **join and measure them**
(`bridge/`), with **machine-checkable gates** (`hooks/`).

```text
fit-to-brand/
  SKILL.md        Router: which layer to run, in which order, how to resume
  icp/            Contested-fit pipeline S0→S5B (situations × incumbents × fit × groups)
  brand/          Gated brand-system workflow Stages 0→11 + Bonus A–E (provider-agnostic)
  bridge/         Join contracts, end-to-end orchestrations, measurement loop
  hooks/          Gate validators: deterministic scripts + judge prompts + approval log
  runs/           Per-run workspaces (git-ignored; see runs/README.md)
```

## The three runs

| Situation | Start here |
|---|---|
| New capability, no brand yet | `bridge/JOINT-RUN-ORCHESTRATION.md` (icp S0→S5B → brand 0→11 → M0→M4) |
| Live brand must change identity | `bridge/REBRAND-ORCHESTRATION.md` (equity guardrails → delta fit → re-Anchor → migration) |
| System is fine, need more assets | `bridge/CAMPAIGN-EXPANSION-ORCHESTRATION.md` (entry gates → thread loop → Bonus → M-loop) |

Join contracts (normative for joint runs): `bridge/AUDIENCE-POSITIONING-BRIDGE.md`
(one audience list, logic/expression split), `bridge/MEASUREMENT-LOOP.md` (M0–M4 market
validity; BENCHMARK stays craft-conformance).

Worked illustrations (fictional SunJar SHS-200, miniature N=6, all figures illustrative):
`bridge/illustrations/ILLU-JOINT-RUN.md`, `ILLU-REBRAND.md`, `ILLU-CAMPAIGN.md` — each
with executable miniature datasets (`data-joint/`, `data-rebrand/`, `data-campaign/`)
and real `hooks/Validate-Gates.ps1` logs (`hook-*.txt`). Start here before your first run.

Conventions: all `like/this.md` paths in docs are repo-root-relative. The skill name
`icp-6` and prose mentions of `icp-6`/`brand-system` refer to the pipelines, not to
old directory names.

## Features

- **Naming** (`bridge/NAMING.md`): criteria derived from theme/stakes/segments/
  incumbents/scope → routes → H1 screens (`hooks/Validate-Naming.ps1`) + J7 judgment
  + human trademark/domain/handle confirms → one pick locked before the Stage 2 kit.
  Rebrand renames supported (OLD joins the confusion corpus via self-as-P-ID).
- **Reports** (`bridge/REPORTS.md`): 9 report kinds at their trigger points, generated
  by a fragments→beats/shape→edit-article→filters pipeline (guides → humanizer →
  guides, per `writing filters/`), each ending with a teach-back footer. Sample:
  `bridge/illustrations/REPORT-SUNJAR-FINAL.md`.

## Ownership rule (prevents all three duplication classes)
- **icp/ owns definition and logic** — countable groups, falsifiable verbs/wedges,
  words. **brand/ owns activation and expression** — threads, pixels, type, scenes.
- **bridge/ owns the join** — Blocks A+B are filled once and imported verbatim, never
  forked. Full analysis in the bridge docs; router `SKILL.md` enforces it per run.

## Gates → hooks (impossible to proceed unchecked)

Every gate is classified and enforced at its trigger point — see `hooks/README.md`
for the full gate→hook matrix. Tier H1 (deterministic: counts, IDs, registries,
coverage) runs as `hooks/Validate-Gates.ps1` and blocks on non-zero exit. Tier H2
(judgment: substance, specificity, audit rubric) runs as structured LLM-judge prompts.
Tier H3 (human approvals: the 4 brand gates, Anchor, launch-hold) is recorded in the
run's gate log, whose *existence* H1 verifies. Elicitation (no silent runs): Q0.0 run
mode first (phased / batch-upfront / defaults), Q-sets per phase in
`bridge/QUESTIONNAIRES.md`, answers in `runs/<id>/PARAMS.log`, H1 `Test-Params` blocks
on missing keys. No stage transition without its hooks green.

Enforcement architecture (platform-agnostic bundle, works on any agent):
**runner** `hooks/ftb.ps1` (`init`/`next`/`ask`/`status`) owns all phase transitions
via `runs/<id>/STATE.json` — the agent's only transition rule; **adapters** in
`hooks/platforms/` wire true blocking where a platform offers pre-tool hooks
(Claude Code guard included, generic + opencode mapping documented); **CI**
`.github/workflows/fit-to-brand-gates.yml` asserts green-fixtures-green,
red-fixtures-red, miniatures green, and any committed `runs/<id>/` snapshot green —
opt a run in with `git add -f runs/<id>`. A skipped check can happen in-chat anywhere;
it cannot land on main anywhere.

## Provenance

- `icp/` — contested-fit pipeline v1.4 as maintained in this workspace (provider-agnostic,
  Markdown + CSV, no vendor dependency).
- `brand/` — Brand System Skill v0.3.0-agnostic (original v0.2.0-alpha by Amir Mushich,
  CC-BY-4.0 — see `brand/LICENSE`; attribution required; provider-agnostic adapter added
  on top, fully backward-compatible with Lovart runs).
- `bridge/` + `hooks/` — joint contracts, orchestrations, and validators built for the
  combined runs in this repo.
