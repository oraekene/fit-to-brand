# Benchmark

Use this rubric to evaluate one complete test run of Brand System Skill (provider-agnostic, v0.3.0+; backward-compatible with Lovart runs). Score each category from **1** (failed or absent) to **5** (consistent and release-ready).

Scope note: this rubric checks **craft conformance** (did the run follow the process and
hold the system?). **Market validity** (did the positioning bet work per group × thread?)
is checked by the joint Measurement Loop M0–M4 — see `bridge/MEASUREMENT-LOOP.md` and
Bonus E. Do not stretch these 7 categories to cover market results.

| # | Category | Score | Evaluation focus |
| --- | --- | ---: | --- |
| 1 | Workflow Compliance | /5 | Stage order, required inputs, checkpoints, and approval gates |
| 2 | User Guidance | /5 | Plain-language onboarding, useful help, and clear next actions |
| 3 | Reference Independence | /5 | Translation of principles without copying reference identity |
| 4 | Anchor Brand Kit Quality | /5 | Coherence, typography specificity, hierarchy, and usability |
| 5 | Brand Adherence | /5 | Consistent use of approved identity across outputs |
| 6 | Brand Lock Performance | /5 | Correct separation of scene, identity, and packaging roles |
| 7 | Correction Quality | /5 | Accurate diagnosis and appropriate refine-versus-restart behavior |
|  | **Total** | **/35** |  |

## Interpretation

- **31–35:** Release-quality workflow for this test case
- **25–30:** Strong, with minor improvements needed
- **18–24:** Functional but requires another iteration
- **Below 18:** Major workflow changes required

## Reusable test report

```text
TEST ID:
SKILL VERSION:
DATE:
PROVIDER PROFILE (image / video / layout / font source + models):
AGENT + REASONING MODE:
LOADING METHOD:
CATEGORY:
NUMBER OF SKUs:
REFERENCE TYPE:

SCORES:
- Workflow Compliance: /5
- User Guidance: /5
- Reference Independence: /5
- Anchor Brand Kit Quality: /5
- Brand Adherence: /5
- Brand Lock Performance: /5
- Correction Quality: /5
- TOTAL: /35

WHAT WORKED:

WHAT FAILED:

UNEXPECTED BEHAVIOR:

MANUAL INTERVENTIONS:

HALLUCINATIONS:

SKIPPED GATES:

PROPOSED CHANGES:
```
