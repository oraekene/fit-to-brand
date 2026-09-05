# REPORTS — plain-language user reports, on rails

Every run produces machine artifacts (CSVs, checkpoints, logs). No user should have
to read them. This system turns each trigger point into one human report: natural,
simple language, every claim traceable to an artifact, no invented numbers, no
generic filler. Reports point at facts; facts live in exactly one place (the run
artifacts). A report that can't cite its line is a draft, not a report.

## (a) Catalog — what can be generated, and when

| Report | Trigger (phase) | Audience | Sources | Journey mode |
|---|---|---|---|---|
| R-S0 Brief Report | Phase 1 end (S0+S1 done) | team | S0_SPEC, theme fork, quotas | shape |
| R-FIT Market Report | Phase 4 end (S5B + Blocks) | founders / GTM | S2/S3/S4/S5A/S5B, Blocks A+B | shape |
| R-NAME Naming Report | N5 lock | team + legal | NAMES.csv, J7 notes, QN rank | shape |
| R-ANCHOR Brand Report | Gate 3 (phase 6) | team + designers | Anchor rules, prohibitions, Block B expression | shape |
| R-THREAD Campaign Plan | Phase 7 end (Stage 9 plan) | media / agents | Block A threads, briefs, formats | shape |
| R-FLIGHT Readout | M3 per flight (phase 10) | owners per PRED-ID | M2_OBS, M3 decisions | beats |
| R-FINAL System Report | Stage 11 + M0 (phase 9) | everyone | all of the above + M_PREDICTIONS | beats |
| R-LEDGER Run Ledger | Phase 10 close (regenerable at any phase) | owners + auditors | PARAMS.log, GATES.log, artifact headers, H1 logs | shape |
| R-MANUAL Brand Manual | Anchor lock (phase 6), refreshed at Stage 11 | team + designers + production | Anchor, Guidelines, Key-Visual, Blocks, Threads, NAMES pick | shape |
| R-MIGRATION Rebrand Report | Rebrand Phase 6 (deprecation) | team + dealers | pairs, probes, deprecation list | beats |
| R-DROP Expansion Report | Campaign Phase 5 | marketing | thread log, audits, M3 | beats |

File convention: `runs/<id>/bridge/R-<KIND>-<slug>.md` (e.g. `R-FINAL-sunjar-001.md`).
QRP.1 (audience + depth skim|standard|deep + language) is briefed at M0/Stage 11 for
R-FINAL and per trigger for the rest; depth skim = decisions + numbers only.

## (b) Generation pipeline (built on the writing skills; completion criteria per step)

Borrowed skeleton, fitted to reports (per writing-great-skills: leading words kept,
each step ends on a checkable criterion, facts keep one source of truth):

1. **Mine — fragments.** Collect the raw pile into `runs/<id>/bridge/REPORT-FRAGMENTS.md`:
   heterogeneous fragments (sharp sentences, claim + one-line justification, vignettes
   from audits and M3 calls, leading words the run coined — *amber rail*, *kill
   latency*). Capture from the first artifact; append-only; `---` separators; no
   headings in the body. Texture rule: the pile must hold ≥3 texture fragments before
   any journey starts — a line someone actually said, a scene someone actually saw, a
   fear in plain words. Reports can only be as vivid as the pile; a pile of pure
   claims produces a flat report no filter can save. *Done when: every source row of
   the catalog entry has ≥1 fragment pointing at it, plus the 3 texture fragments.*
2. **Journey — beats or shape.** Settle prerequisites first: what this reader already
   knows (beats grounding). Story-first reports (FINAL, MIGRATION, FLIGHT) run
   beat-by-beat: 2–3 candidate openings, user picks, one beat at a time, each
   reachable from grounded concepts. Spec-first reports (the rest) run
   paragraph-by-paragraph with explicit format arguments (prose for argument, lists
   for parallel items, tables for repeating shapes — never a list of non-parallels).
   Mine the pile; leftover fragments are fine. *Done when: the user says the journey
   ends (beats) or every contract section is filled (shape).*
3. **Revise — edit-article.** Divide by headings, check the section order respects
   dependency (no beat leans on an ungrounded concept), then clarity pass.
   *Done when: order verified + each section earns its place (cut what doesn't).*
4. **Filters sandwich (c) — guides → humanizer → guides.** *Done when: zero bans
   remain and no claim moved.*
5. **Teach-back footer.** Every report ends with: mission line (why this report, for
   this reader), prerequisites it assumed, follow-up questions for the agent, and a
   decisions log (non-obvious calls that may need revisiting — learning-record
   spirit). *Done when: a cold reader knows what to ask next.*
   Pipeline trace (which stages ran, fragment counts, filter passes) is builder
   provenance, not reader content: record it in `GATES.log`
   (`R-<KIND> generated: fragments N → beats|shape → edit → guides→humanizer→guides`),
   never in the report body. The report carries bracket citations to artifacts; the
   log carries how it was made.

## (c) Writing filters (in `writing filters/`, applied in this order — final)

1. **`soem writing guides` first — draft against the bans.** Portable core (the
   cover-letter openers/closers stay in their domain; everything structural carries
   over): no rhetorical scaffolding (antithesis, corrective negation, rule of three,
   setup/payoff, landing sentences, summary beats), no stacked noun phrases, no
   filler intensifiers, no corporate-register verbs (leverage, drive, enable,
   showcase…), no hedging qualifiers unless the hedge is the claim, no performed
   enthusiasm, spoken-voice test (read aloud; anything unsayable across a table goes).
   Report-specific additions: **no invented numbers** (every figure cites its
   artifact line), **no claim drift** (segment claims keep adjacent evidence — the
   guides' "say the thing, not the label" rule), **no generic positive endings**
   (end on the last concrete fact or next action, never a send-off).
2. **`SKILL-humanizer` second — phrasing pass only.** Strip AI tells (§1–35) without
   touching any number, claim, or fact the pipeline already set — exactly the guides'
   own scope rule. If a humanizer suggestion would change what a line claims, reject
   it back to step 1's territory.
3. **`soem writing guides` third — re-check, not optional.** The humanizer is general
   and can reintroduce a banned shape while fixing a word. The guides' own text names
   this the most-skipped step and the reason output drifts generic. Check, fix, ship.

### Voice budget (what the filters don't ban — spend it deliberately)

The bans above remove scaffolding *standing in for* content. They do not ban voice,
but a run that applies only the bans converges on flat. So every report earns this
budget explicitly, and the journey step must spend most of it:

- **One vignette opener** (beats reports) or one concrete scene inside the first
  section (shape reports) — a pilot night, a shelf under fluorescents, a quote from
  a pitch. Mined from texture fragments, never invented at draft time.
- **One genuine aside** (parenthetical, humanizer's own keep-list): a doubt, a
  mixed feeling, a self-correction. Felt stakes with numbers attached stay; performed
  enthusiasm goes.
- **Concrete nouns over abstract labels**, sentence lengths unpredictable (the guides
  demand this already — enforce it: no two adjacent paragraphs with the same shape),
  spoken-voice test throughout.
- **Counterweight, applied by name:** the humanizer's "Human details to keep" —
  specific unusual details, mixed feelings, asides, varied rhythm. The step-2 pass
  must check for their *presence*, not just for tells' absence. A draft with zero
  tells and zero details fails this check and returns to journey.
- **Earned relaxations (rare, never default):** a single short punch sentence (never
  a stack); a three-count only when the count is real (three buyer groups is a fact,
  not padding); one closing decision line at the very end. Each needs a reason
  recorded — "earned" means defensible, not decorated.
- Cover-letter-specific bans map across as: throat-clearing covers report openers
  ("This report provides an overview of…" goes); generic-positive-endings covers
  send-off closers (end on the last concrete fact or next action).

## Per-report contracts (must-contain; shape reports)

- **R-S0:** problem in one paragraph; solution in one; Out-of-Scope list verbatim;
  quotas + run-mode + overlay and what each licenses; acceptance test.
- **R-FIT:** Top-K situations in plain words; stakes in money terms (both lenses);
  incumbent shelf in one paragraph per threat; fit verdicts per group (swap vs wedge,
  in words not verbs); groups + objections + answers; NOT-fit boundaries.
- **R-NAME:** criteria + rank; routes tried; screens (what each rejection cost);
  the pick + why in two sentences; manual checks status.
- **R-ANCHOR:** the system in plain words (no jargon: name colors, fonts, device,
  zones like rooms in a house if that helps); prohibited list; what survives contact
  with dealers/print/screens.
- **R-THREAD:** matrix scene×SKU×format per group; which brief line each thread
  carries; what may change per thread (nothing else).
- **R-FLIGHT:** prediction vs observed per PRED-ID; verdict + address; kill latency;
  what happens next, by owner and date.
- **R-FINAL:** the run's story (beats); market, system, measurement, open issues,
  next steps; M0 baseline pointer.
- **R-LEDGER:** one section per phase (0–10): questions asked, answers given
  (value + src + who + date), artifacts written, gate verdicts (H1/H2/H3),
  decisions taken; open issues; next steps. Body is compiler-first
  (`hooks/Build-Ledger.ps1` emits it from PARAMS.log + GATES.log + artifact
  presence — never hand-typed from memory); the agent verifies it against the
  artifacts and appends the teach-back footer.
- **R-MANUAL:** the agency-style handoff book: cover (pick wordmark on the
  rail), identity + promise in two sentences, logo lockups + clearspace +
  minimum sizes + misuses, typography plates (families, roles, scale,
  register samples), color plates (values, proportions, SKU logic), device
  states (rail-plus-chip PASS/KILL/PLANNED), packaging zones, key visual +
  cross-SKU validation, one thread sheet per group (headline, proofs, CTA,
  formats), prohibited styles, production limitations, image credits (render
  path + Figma finish). Missing renders ship as labeled placeholder boxes,
  never broken images. Designed for the export chain ((d) below).
- **R-MIGRATION:** old→new mapping; pairs verdict; probe numbers; deprecation dates.
- **R-DROP:** what shipped per thread; audits survived; M verdicts; cost actuals.

Sample execution: `bridge/illustrations/REPORT-SUNJAR-FINAL.md` (R-FINAL, standard
depth, produced by running this pipeline on `data-joint/`).

## (d) Export — Markdown to HTML to PDF (reports that carry images and finished type)

Reports are authored in Markdown and stay Markdown in the run. When a report
must show images or finished type (R-MANUAL always; any R-* on request), emit
HTML + PDF alongside the `.md` via `hooks/Export-Report.ps1`:

```powershell
./hooks/Export-Report.ps1 -Path runs/<id>/bridge/R-FINAL-<slug>.md
# writes R-FINAL-<slug>.html + R-FINAL-<slug>.pdf next to it
```

Chain: pandoc (Markdown → standalone HTML5, print stylesheet
`hooks/export/print.css`) → Edge/Chromium headless `--print-to-pdf` (A4,
background graphics on, no header/footer). Images resolve relative to the
`.md`; missing renders must be labeled placeholder boxes in the source, never
dangling `<img>` (a PDF with broken images is a draft, not a deliverable).
Tool prerequisites live in `REQUIREMENTS.md`. The export is a render, not a
rewrite: the `.md` stays the source of truth; re-export after any edit.
