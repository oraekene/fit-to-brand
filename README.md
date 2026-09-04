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

Conventions: all `like/this.md` paths in docs are repo-root-relative. The skill name
`icp-6` and prose mentions of `icp-6`/`brand-system` refer to the pipelines, not to
old directory names.

## Ownership rule (prevents all three duplication classes)
- **icp/ owns definition and logic** — countable groups, falsifiable verbs/wedges,
  words. **brand/ owns activation and expression** — threads, pixels, type, scenes.
- **bridge/ owns the join** — Blocks A+B are filled once and imported verbatim, never
  forked. Full analysis in the bridge docs; router `SKILL.md` enforces it per run.

## Gates → hooks

Every gate is classified and enforced at its trigger point — see `hooks/README.md`
for the full gate→hook matrix. Tier H1 (deterministic: counts, IDs, registries,
coverage) runs as `hooks/Validate-Gates.ps1` and blocks on non-zero exit. Tier H2
(judgment: substance, specificity, audit rubric) runs as structured LLM-judge prompts.
Tier H3 (human approvals: the 4 brand gates, Anchor, launch-hold) is recorded in the
run's gate log, whose *existence* H1 verifies. No stage transition without its hooks
green.

## Provenance

- `icp/` — contested-fit pipeline v1.4 as maintained in this workspace (provider-agnostic,
  Markdown + CSV, no vendor dependency).
- `brand/` — Brand System Skill v0.3.0-agnostic (original v0.2.0-alpha by Amir Mushich,
  CC-BY-4.0 — see `brand/LICENSE`; attribution required; provider-agnostic adapter added
  on top, fully backward-compatible with Lovart runs).
- `bridge/` + `hooks/` — joint contracts, orchestrations, and validators built for the
  combined runs in this repo.
