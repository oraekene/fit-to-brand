# Joint Measurement Loop M0–M4 (icp-6 × brand-system)

Status: normative for joint runs that reach market; lightweight variant for pre-launch.
Neither skill ships this today: icp-6 gates check **conformance**
(counts/IDs/grammar/format/honesty — `icp/references/gates.md`), brand BENCHMARK
(35-pt rubric, `brand/BENCHMARK.md`) checks **craft conformance**.
Neither checks **market validity**. This loop adds it without rewriting either pipeline:
S0–S5B and Stages 0–11 stay untouched; M-stages run after lock and feed back in.

## Design principles

1. Measure the **join key**, not each skill in isolation: performance is recorded per
   `(GRP-ID × asset-thread)`, so a result attributes to both a positioning bet (icp-6)
   and an expression bet (brand). Solo-skill metrics are diagnostic only.
2. Separate **leading** (cheap, fast: audit PASS rate, text-render errors, recall
   checks, CTR) from **lagging** (slow, expensive: meetings, pilots, revenue, retraining
   cost). Never reposition on leading alone; never wait for lagging to fix craft.
3. Pre-register predictions: every S5B brief + thread row ships with a falsifiable
   expectation (M0). A result without a prediction is logging, not measurement.
4. Smallest instrument that can kill a bad bet: one tracked CTA per thread, one
   confusion probe per NOT-fit boundary, one cost line per asset. Expand only on signal.
5. Feedback has named addresses: every finding lands in exactly one backlog —
   S3 anchor, S5A verb/landing, S5B brief, Anchor rule, prohibited-styles, or Provider
   Profile workaround. "General learnings" are not allowed to evaporate.

## Stages

### M0 — Baseline & predictions (runs at brand Stage 11 / icp-6 S5B completion)

Inputs: `S5B_GROUPS.csv` annex (Blocks A+B), Anchor rules, thread matrix (scene × SKU ×
format per group), Provider Profile + cost unit.
Outputs: `M0_BASELINE.md` + `M_PREDICTIONS.csv`, one row per `(GRP-ID × thread)`:

```text
PRED-ID | GRP-ID | THREAD (scene/SKU/format) | PREDICTION (e.g. "GRP-03 shelf 4:5 ≥2.1% CTR, confusion-with-P-0014 <8%") |
LEADING-METRICS (names) | LAGGING-METRIC (name) | SAMPLE-NEEDED | COST-CAP (profile cost unit) |
KILL-CONDITION ("if CTR <1.0% after N, kill thread, keep group") |
REPOSITION-CONDITION ("if objection-answer fails 3/5 sales calls, reopen S5B GRP-03") |
OWNER | DATE
```

Gate (M0): every scaled thread has a prediction row with kill + reposition conditions,
or `STATUS: unaddressed`. No prediction → no scale (extends brand Rule 11:
audit-before-scale becomes audit-plus-prediction-before-scale).

Pre-launch lightweight variant: replace market metrics with 5-person confusion/recall
probes per thread (recognize brand? name wedge? confuse with P-ID?) + production-cost
actuals. Same schema, `SAMPLE-NEEDED: 5`, lagging metric `N/A: pre-launch`.

### M1 — Instrument (before any spend)

- One tracked CTA per thread (UTM / code / QR / rep-task-ID per overlay: GTM link,
  OPS task-ID, EDU assignment-ID, SUBSISTENCE co-op tally).
- One confusion probe per NOT-fit boundary ("which product is this most like?" with
  the must-not-resemble P-ID as an option).
- One cost line per asset in the Provider Profile's cost unit (credits/tokens/$/render-min),
  plus human finishing minutes (layout, retouch, legal check).
- Record placement context (channel enum from overlay + actual format + flight dates).
  Output: `M1_INSTRUMENT.md` checklist, signed before flight. Untracked threads do not fly.

### M2 — Collect (during flight)

Append-only `M2_OBS.csv`:

```text
DATE | PRED-ID | GRP-ID | IMPRESSIONS/REACH | CLICKS/RESPONSES | CONFUSION-HITS (n + confused-with P-ID) |
TEXT-DEFECTS (n, e.g. misspelled pack copy) | PRODUCTION-MINUTES | SPEND (cost unit) |
LAGGING-EVENTS (meetings/pilots/orders/task-completions per overlay) | NOTES
```

Cadence: leading metrics weekly (or per 1k impressions for low-volume / per 5 sales
calls for enterprise motion); lagging per motion cycle (PLG: 2 weeks; enterprise: one
pipeline review; OPS/EDU: one exercise / cohort). Subsistence: per market-day / co-op cycle
with staple-equivalent revenue where money is absent (mirrors O-SUBSISTENCE pricing rule).

### M3 — Judge (attribute + decide: keep / fix-craft / fix-logic / kill)

Decision table per PRED-ID, reviewed at cadence:

| Signal pattern | Verdict | Address |
|---|---|---|
| Leading ✓, lagging ✓ | `SCALE` | Add formats/scenes for this GRP-ID; keep logic+expression |
| Leading ✓, lagging ✗ | `FIX-LOGIC` | Expression works, bet wrong: reopen icp-6 S5A/S5B for this GRP-ID (wedge? objection-answer? motion? budget?) — do not redesign the kit |
| Leading ✗ (low CTR/recall), lagging n/a | `FIX-CRAFT` | Bet untested: brand audit → correction loop (hierarchy? proof order? CTA hardness? format recompose?) — do not reposition yet |
| High confusion-with-P-ID | `FIX-BOUNDARY` | Visual/claim too close to incumbent: strengthen NOT-fit + prohibited-styles + pack differentiation; re-test with 5-person probe before reflight |
| Text-defects / audit FAILs in flight | `FIX-PROVIDER` | Provider limitation (text-in-image, aspect, motion): change Provider Profile workaround or layout-tool finishing step; log in Generation Plan history |
| Leading ✗ + lagging ✗ after fix cycle | `KILL-THREAD` (keep group) or `KILL-GROUP` (retire GRP-ID to findings) | Thread kill preserves group; group kill requires S5B re-group note + brief retirement |

Output: `M3_DECISIONS.md` with one verdict + address per PRED-ID. No verdict without an
address. No address outside the six backlogs above.

### M4 — Feed back (write to the owning artifact, then re-gate)

| Finding type | Written to | Re-gate |
|---|---|---|
| Stakes miscalibration (predicted ticket/failure vs observed) | S3 `price_note` + anchor_source append; livelihood note if subsistence | S3 $0/flag + currency rules still pass |
| Verb/wedge wrong (clicked, didn't convert) | S5A verb change or wedge rewrite + new landing_place/spec cite; old row kept as superseded | S5A landing+cite + NOT-fit + single-pass rules |
| Brief/objection wrong (answered objection still kills deals) | S5B brief rewrite for that GRP-ID; objection → answer updated; brief count = group count preserved | S5B mix/motion/noun-registry gates |
| Visual drift that worked (deviation outperformed Anchor) | Anchor rule amendment via brand `GO BACK` (downstream invalidation stated) — never silent drift | Guideline modules + Brand Lock re-audit |
| Visual confusion with P-ID | S4 findings + S5A NOT-fit reason + brand prohibited-styles | Both gates |
| Provider workaround validated/failed | Provider Profile fallbacks + Generation Plan template note | Next Generation Plan cites it |
| Dead group | S5B findings + Block A `STATUS: killed` + brief retired (count gate preserved by retirement note, not deletion) | Count gate via explicit retirement |

After M4, toggles re-render (icp-6 T1–T7) and responsive/localized/motion extensions
(brand Bonus A–D) regenerate from the amended sources — cores are never re-run to chase
a render.

## Metric sets (pick per overlay; all per GRP-ID × thread)

- Strategy-validity (icp-6 side): brief→response rate, objection-overcome rate (sales-call
  or task-accept log), wedge-recall ("why us vs P-ID?" unprompted mention), NOT-fit
  precision (confusion-with-P-ID rate), stakes calibration error (|predicted − observed| ticket).
- Craft-consistency (brand side): audit PASS rate pre-flight, correction cycles per asset,
  text-defect rate, cross-SKU recognition ("same brand?" %), cross-format hierarchy survival
  (Bonus A check), production minutes per asset vs estimate.
- Joint efficiency: cost per response and per lagging event in the profile's cost unit;
  kill latency (days from kill-condition trip to actual kill — the loop's own KPI).
- Overlay swaps: OPS uses task-accept / intent-clarity; EDU uses objective-mastery checks
  + assignment completion; SUBSISTENCE uses co-op/market-day tallies + staple-equivalents.
  Never force CTR/revenue where the overlay's brief format has no CTA.

## Minimal file set (lives in `bridge/` for joint runs; solo runs subset)

- `M0_BASELINE.md`, `M_PREDICTIONS.csv`, `M1_INSTRUMENT.md`, `M2_OBS.csv`,
  `M3_DECISIONS.md` (+ M4 writes go to owning artifacts, not new files).
- Naming: prefix run ID (`<project>-M*.csv`) so parallel runs never collide.

## Anti-patterns (kill the loop, not the product)

- Repositioning on leading metrics alone (fix-craft misdiagnosed as fix-logic).
- Redesigning the kit when the wedge is wrong (fix-logic misdiagnosed as fix-craft).
- Averaging across GRP-IDs (a winning group hides two dead ones — judge per PRED-ID).
- Editing locked logic columns silently from thread results (always via M4 addresses).
- Flying untracked assets "to learn faster" (learning without an address is spend).
