# S1 — Theme distillation (RTD)

## Rule
Save the ladder trace, not just the word. A one-word theme file with no worksheet repeats S1-2 and lets grammar bugs like `Decisions making` through (cures S1-1).

## Ladder (Levels 0-6)
0. Raw Inventory — list subsystems from headers/ToC, no paraphrase.
1. Mechanism Ablation — `named-technique for Y` becomes `Y`.
2. Domain Ablation — replace field nouns with domain-neutral roles; test by swapping fields.
3. Axis Canonicalization — Activity verb/gerund, Category noun.
4. Need Laddering — chain `why is that needed`, drop the final universal rung, keep the rung before it.
5. Convergence — axes agree to one word; Need diverging gives qualifier + noun (Minimal Compound Rule).
6. Validation battery — all five or the candidate ships nowhere.

## Battery
Distinctiveness (wrong for most unrelated projects), Reconstruction (80%+ of Level-0 explainable), Portability (survives a domain swap), Collapse (removing it removes the reason to exist), Minimality (<=3 words, every word earns its place). Full definitions, worked ADIE pass, calibration passes, failure modes and distributional scoring live in the intact source: read [RTD_full.md](RTD_full.md) when any battery test is ambiguous or any ladder step stalls — this file is the checklist, that file is the authority.

## Fork
Two candidates clearing the battery with no dominance ship both, labeled `theme_broad` and `theme_sharp` (e.g. `decision making` + `leveraged decisions`; `knowledgebase` ships alone). Tag every S2-S5 run with which theme it used. Cures S1-3.

## Worksheet fields
Level-0 inventory | L1 stripped | L2 roles | Activity | Category | Need (last non-universal rung) | convergence type | candidate(s) | five pass/fail boxes | final theme(s).

## Prompt
> Run RTD Levels 0-6 on S0_SPEC.md. Return the filled worksheet, the battery table, and theme_broad + theme_sharp. Enforce Minimality and grammatical number agreement.

## Completion check
Worksheet plus battery saved, theme grammatical and <=3 words, fork recorded.
