# Recursive Theme Distillation (RTD)
## A Deterministic Framework for Extracting a Project's Core Theme

**Purpose:** Given any project spec, however large or jargon-dense, reduce it — level by level, via repeated ablation — to the single word (or ≤3-word phrase) that names its irreducible core. Calibrated against your own settled answers: *knowledgebase*, *decision making*, *winning strategy*, *uninterrupted power*.

---

## Contents

1. Design Philosophy
2. The Three Abstraction Axes
3. The Ladder — Level 0 through Level 6
4. The Validation Battery (deterministic stop condition)
5. The Minimal Compound Rule (how to phrase the output)
6. Epistemic Fork (when not to force a single answer)
7. Worked Example — Deep Pass on ADIE
8. Calibration Passes — Your Other Three Projects
9. Failure Modes / Anti-Patterns
10. Operator's Checklist (condensed procedure)
11. Reusable Worksheet
12. Formal Rationale (MDL framing)
13. Distributional Scoring — Borrowing Next-Token-Prediction Mechanics

---

## 1. Design Philosophy

A single-word "summary" produced by asking an LLM to just guess is not reproducible — ask again, phrase it differently, get a different word. That's not a framework, it's a mood. RTD fixes this the same way your own ADIE spec fixes decision-making: by separating the parts that are *mechanical* (no discretion, same output every time) from the parts that require *bounded judgment* (discretion, but constrained by explicit pass/fail tests rather than vibes).

Governing principles:

1. **Ablate mechanism before you ablate meaning.** Strip *how* a thing works before you try to name *what* it's for — otherwise the theme just becomes the name of the loudest algorithm in the spec.
2. **Three axes, not one.** A project's identity lives at the intersection of what it lets you *do*, what genus of thing it *is*, and what deeper *need* it satisfies. Collapsing straight to one axis is how you get either too-narrow (mechanism leak) or too-broad (tautology) answers.
3. **The stopping point is a test battery, not a feeling.** "Deep enough" is defined by five falsifiable checks (Section 4), not by when the abstraction *sounds* profound.
4. **Never force a single word past the point where it stops discriminating.** If a bare word already uniquely identifies the project's territory, stop — don't decorate it. If it doesn't, add exactly one qualifier, no more.
5. **When two candidates survive with no dominance, output both.** This is the direct analog of ADIE's own Epistemic Halt: the system doesn't guess past the edge of what the evidence supports.

---

## 2. The Three Abstraction Axes

Every project can be described along three independent axes. Your four examples each anchor primarily on one or two of these — which is itself diagnostic (see Section 5).

| Axis | Question it answers | Grammatical form | Example |
|---|---|---|---|
| **Activity** | What does it let the user *do*? | verb / gerund | "deciding," "searching," "sizing" |
| **Category** | What genus of *artifact* does the user walk away with or use? | noun | "knowledgebase," "strategy," "power system" |
| **Need** | What deeper want does that activity/artifact ultimately serve? (Aristotle's *telos*) | noun / adjective+noun | "leverage," "winning," "continuity" |

Most naive "one-word summary" attempts only ever query the Activity axis, which is exactly why they drift toward mechanism ("minimax engine") or toward marketing ("empowerment"). RTD forces all three to be extracted independently, then checks where they agree and where they don't.

---

## 3. The Ladder — Level 0 through Level 6

Work top to bottom. Each level has an explicit operation. Levels 0–2 are mechanical (same output regardless of who runs it). Levels 3–5 are bounded judgment. Level 6 is a hard gate.

**Level 0 — Raw Inventory** *(mechanical)*
List every discrete subsystem/feature, pulled directly from the spec's own headers, ToC, and executive summary. Do not paraphrase yet. This is a literal extraction.

**Level 1 — Mechanism Ablation** *(strip the HOW)*
For every Level-0 item phrased as "[named technique] for [purpose]," discard the technique name and keep only the purpose. Rule: `"named-algorithm X for Y" → "Y"`.

**Level 2 — Domain Ablation** *(strip the WHERE)*
Replace subject-matter-specific nouns (the field the spec happens to use as its example — finance, negotiation, solar, notes) with domain-neutral role descriptions. Test as you go: *could this exact operation occur in a completely unrelated field?* If no, you haven't ablated enough.

**Level 3 — Axis Canonicalization** *(judgment, bounded)*
- **Activity candidate:** cluster the Level-2 operations by shared purpose; name the cluster with one verb/gerund.
- **Category candidate:** ask "what class of thing does the user walk away with or use?"; name it with one noun.

**Level 4 — Need Laddering** *(judgment, bounded)*
Chain "why is that needed?" starting from the Activity candidate. Stop the instant an answer becomes near-universal (true of almost any product — "to get better outcomes," "to save time," "to succeed"). Discard that final universal rung; the **previous** rung is your Need candidate. This single rule is what prevents tautology collapse (Section 9).

**Level 5 — Convergence & Compression** *(judgment, bounded)*
Compare the three candidates:
- If Activity ≈ Category ≈ Need (all point at the same concept) → strong single-word candidate.
- If Need diverges from Activity/Category → Need becomes the **qualifier**, Activity/Category becomes the **core noun** → 2-word candidate (see Section 5).

**Level 6 — Validation** *(hard gate, mechanical once axes are fixed)*
Run the candidate(s) through the battery in Section 4. Anything that fails gets kicked back to Level 3–5, not accepted with an asterisk.

---

## 4. The Validation Battery (deterministic stop condition)

A candidate is only accepted if it clears all five. This is what makes the *endpoint* deterministic even though the *path* involves judgment — two people running the ladder on the same spec should converge on the same surviving candidate, because "survives all five tests" is a much narrower target than "sounds right."

| Test | Passes when | Fails when |
|---|---|---|
| **Distinctiveness** | The candidate would be *wrong* or *irrelevant* as the theme of most unrelated projects | The candidate applies equally well to almost any software project ("system," "tool," "efficiency," "value") |
| **Reconstruction** | ~80%+ of the Level-0 feature inventory can be explained as a specific instance of the candidate | Large parts of Level-0 have no relationship to the candidate — it's describing a different project |
| **Portability** | The candidate still makes complete sense with the domain swapped out entirely | The candidate needs this project's specific subject-matter vocabulary to parse |
| **Collapse** | Removing the candidate's concept from the project would strip its reason to exist / make it a different, lesser product | The project's core value is fully intact without the candidate — it was decoration, not load-bearing |
| **Minimality** | ≤3 words, and every word is doing work no other word already covers | >3 words, or a qualifier can be dropped without failing Distinctiveness or Reconstruction |

If **zero** candidates survive: the axis-naming at Level 3/4 was too loose or too tight. Don't force an answer — go back one level and re-cluster or re-ladder.

---

## 5. The Minimal Compound Rule

Looking at your four settled examples structurally:

| Project | Bare category alone distinctive? | Theme |
|---|---|---|
| QMD storage/search | Yes — "knowledgebase" already discriminates | **knowledgebase** *(0 qualifiers)* |
| ADIE | No — "decision(-making)" is shared by nearly every decision-support product | needs a qualifier |
| Prediction-market strategy builder | No — "strategy" alone fits almost any business tool | **winning** + strategy |
| Solarsizer / SolarOne | No — "power" alone is unbounded | **uninterrupted** + power |

**The rule:** start with the bare Category (or Activity) noun from Level 3. Run Distinctiveness. If it passes on its own, stop — that's the whole theme, one word. If it fails, take the Need-axis candidate from Level 4 and prepend it as a single adjective/gerund qualifier. Never stack a second qualifier — if two words still fail the battery, the Level 3 noun itself was wrong, not under-decorated. Re-derive the noun rather than adding a third word.

This is exactly why "knowledgebase" needed nothing and the other three needed one modifier each — it's not stylistic inconsistency in your own naming, it's the battery doing its job differently depending on how generic the bare noun happens to be.

---

## 6. Epistemic Fork

Direct analog of ADIE's own Epistemic Halt (§12 of your spec): *the LLM must ask rather than guess when information is genuinely insufficient.* Applied here: **if two candidates both clear all five tests and neither dominates the other on Reconstruction coverage, output both, labeled, and let the human pick** — don't force a false single answer. A forced tie-break at this stage is exactly the kind of unjustified discretion the rest of the framework exists to eliminate.

---

## 7. Worked Example — Deep Pass on ADIE

**Level 0 (raw inventory, from your own ToC/exec summary):** Interview Module, Leverage Mapping Engine, Game Theory / Pareto Analysis, Minimax Decision Engine, Leverage-Modified Minimax Solver, Hidden Leverage Detection, Epistemic Halt Mechanism, Utility Quantification, Persistent Storage & Retrieval (QMD), Orchestrator, Prompt Architecture.

**Level 1 (mechanism ablation):**
Minimax Engine → worst-case risk evaluation. Pareto/Game Theory → mutual-benefit search. Leverage Mapping / Hidden Leverage Detection → power-and-advantage assessment (including advantage the user doesn't know they have). Epistemic Halt → uncertainty checkpoint. Persistent Storage → context memory across sessions.

**Level 2 (domain ablation):** all of the above are already domain-neutral — none require "negotiation" or "finance" specifically; your own spec makes this explicit (§1.4: Determinism First, Leverage-Aware, applicable to any decision).

**Level 3 — Axis candidates:**
- *Activity:* the cluster {risk evaluation, mutual-benefit search, power assessment, uncertainty checkpoint, context memory} all serve one act → **deciding**.
- *Category:* what the user walks away with is a recommendation grounded in a specific decision → **decision(-support)**.

Activity and Category converge cleanly on **"decision making."** This is your own stated answer, and the framework reproduces it independently — good confirming signal.

**Level 4 — Need laddering:** Why decision-making? → to avoid costly mistakes and capture advantage the user has but doesn't see → why? → to get a better outcome → **stop** (that rung is universal — true of literally every product). Take the previous rung: the Need-axis candidate is **leverage** — specifically, *acting on actual leverage instead of perceived leverage*, which your own spec names as *the* v3.1 differentiator (§1.2–1.3: "The v3.1 Innovation: Leverage Mapping," "Users make decisions based on their perceived leverage, not their actual leverage").

**Level 5 — Convergence check:** Activity/Category ("decision making") and Need ("leverage") **diverge**. Per the Minimal Compound Rule, this means Need becomes the qualifier: candidate B = **"leveraged decisions"** (or "leverage-aware decisions"), sitting alongside candidate A = bare **"decision making."**

**Level 6 — Validation battery, run on both:**

| Test | "Decision making" | "Leveraged decisions" |
|---|---|---|
| Distinctiveness | **Fail** — true of any pros/cons app, any consulting tool | **Pass** — narrows to the specific class of systems that price in real vs. felt power |
| Reconstruction | Partial — explains Phases 1–3 generally but doesn't explain *why an entire dedicated Phase 1.5 exists* | **Pass, higher fidelity** — Leverage Mapping, Hidden Leverage Detection, leverage-adjusted Minimax, and leverage-informed Pareto search are all *directly* named by the candidate |
| Portability | Pass | Pass — leverage transfers to negotiation, career moves, litigation, pricing, relationships |
| Collapse | Pass, trivially (removing "decisions" removes everything) | **Pass, meaningfully** — remove leverage-mapping specifically and ADIE becomes a generic minimax+Pareto calculator, a materially different and less distinctive product, per your own §1.2 framing |
| Minimality | Pass (1 word) | Pass (2 words) |

**Result:** "decision making" is a correct but *one rung too high* on this ladder — it's the genus, not the differentiator. "Leveraged decisions" is the theme that survives the full battery without a partial on Reconstruction. Per the Epistemic Fork rule, since both technically pass four of five and only Distinctiveness cleanly separates them, I'd present this as: **"decision making"** is the safe, broad-umbrella answer (fine if you ever want to fold non-leverage decision tools under the same banner); **"leveraged decisions"** is the rigorous, fully-validated one specific to what v3.1 actually is. Your call which one you're optimizing the label for — this isn't me overriding your example, it's what the battery surfaces when applied strictly.

---

## 8. Calibration Passes — Your Other Three Projects

*(Lower confidence — no spec attached, working only from your one-line descriptions. These exist to sanity-check that the framework's mechanics reproduce your own settled answers, and to show why each one needed a different word-count.)*

**QMD storage/search → "knowledgebase."** Category axis alone: a repository of structured, retrievable notes is a real, bounded, recognized genus term — it already fails to describe unrelated software (Distinctiveness: pass, unaided). No Need-axis qualifier required. Zero-qualifier outcome, matching Section 5's rule.

**Prediction-market strategy builder → "winning strategy."** Category axis bare ("strategy") fails Distinctiveness — nearly any planning tool qualifies. Need axis: why build a strategy → to win/profit, which is also exactly what makes it generalize past finance (Portability: pass) since "winning" is domain-neutral. One-qualifier outcome.

**Solarsizer / SolarOne → "uninterrupted power."** Category axis bare ("power") fails Distinctiveness — unbounded, applies to any electrical topic. Need axis: why size a solar+battery system → to keep power flowing through outages, i.e., continuity rather than raw generation capacity. One-qualifier outcome, and it explains why the theme is about *continuity* rather than, say, "solar power" or "clean energy" — those would describe the mechanism, not the need (a generator or a UPS serving the same need would still qualify under "uninterrupted power" but not under "solar power" — a good Portability check).

---

## 9. Failure Modes / Anti-Patterns

- **Mechanism leak.** Theme names the algorithm instead of the function ("minimax engine" instead of "decision making"). Symptom: you skipped Level 1.
- **Tautology collapse.** Laddering "why" past the universal rung and keeping it anyway — landing on "value," "growth," "success," "efficiency," "empowerment." These words are always wrong; they're semantic nulls that fit every product ever built. If you land here, back up one rung.
- **Premature convergence (under-abstraction).** Theme still contains this project's specific domain vocabulary — fails Portability. Symptom: you skipped or rushed Level 2.
- **Marketing contamination.** Pulling the theme from the project's own tagline/README instead of re-deriving it from the Level-0 inventory. Always check: does this word survive if you cover up the marketing copy and only look at the feature list?
- **False convergence.** Activity and Category *look* like they agree only because both were stated vaguely. Fix: restate each axis in its most precise form before comparing — vague terms agree with everything.

---

## 10. Operator's Checklist (condensed)

```
1. INVENTORY        — list every major subsystem/feature from headers/ToC.        [mechanical]
2. STRIP MECHANISM   — "named technique for Y" → "Y".                              [mechanical]
3. STRIP DOMAIN      — replace subject-matter nouns with domain-neutral roles.      [semi-mechanical]
4. NAME ACTIVITY     — cluster by shared purpose → one verb/gerund.                 [judgment]
5. NAME CATEGORY     — "what genus does the user walk away with?" → one noun.       [judgment]
6. LADDER THE WHY    — chain "why is that needed" → drop the final universal rung,
                        keep the rung before it as Need axis.                        [judgment]
7. COMPARE AXES      — Activity≈Category≈Need → 1-word candidate.
                        Need diverges → qualifier(Need) + noun(Activity/Category).
8. VALIDATE          — Distinctiveness, Reconstruction, Portability, Collapse,
                        Minimality. All five or it doesn't ship.
9. IF one candidate survives clean       → output it.
   IF multiple survive, none dominates   → output all (Epistemic Fork).
   IF none survive                        → return to step 4/5/6, re-derive.
```

---

## 11. Reusable Worksheet

| Field | Your input |
|---|---|
| Project name | |
| Level-0 feature inventory | |
| Level-1 mechanism-stripped operations | |
| Level-2 domain-stripped roles | |
| Activity-axis candidate | |
| Category-axis candidate | |
| Need-axis candidate (last non-universal "why" rung) | |
| Convergence type | ☐ single word ☐ qualifier + noun |
| Candidate theme(s) | |
| Distinctiveness | ☐ pass ☐ fail |
| Reconstruction | ☐ pass ☐ fail |
| Portability | ☐ pass ☐ fail |
| Collapse | ☐ pass ☐ fail |
| Minimality | ☐ pass ☐ fail |
| **Final theme** | |

---

## 12. Formal Rationale (MDL framing, optional)

If you want the intuition behind why the Reconstruction test is the real anchor: think of the theme as a compression of the Level-0 feature list. A theme that's too broad ("system") compresses perfectly but reconstructs nothing — infinite ambiguity about what features it implies. A theme that's too narrow (the literal feature list itself) reconstructs perfectly but compresses nothing — it's not an abstraction at all, just a restatement. The correct theme is the shortest label from which the Level-0 inventory is the *most predictable*, non-arbitrary derivation — maximum compression subject to the constraint that reconstruction fidelity stays above the 80% floor in Section 4. This is the same trade-off Minimum Description Length formalizes for model selection generally; it's not being invoked here as literal math, just as the reason "shortest label that still explains the most" is a principled target rather than an aesthetic preference.

---

## 13. Distributional Scoring — Borrowing Next-Token-Prediction Mechanics

Sections 1–12 treat candidate generation and validation as judgment calls constrained by pass/fail tests. There's a second, complementary track: instead of asking a model to *generate* a theme once, treat it as a **distribution over next words** and interrogate that distribution directly — closer to what next-token prediction actually is mechanically, and it turns some of the qualitative RTD tests into computable scores.

### 13.1 What's actually being borrowed

Four specific mechanics, each mapping onto a piece of RTD:

| LLM mechanic | What it actually is | What it operationalizes in RTD |
|---|---|---|
| **The next-token distribution** | A model doesn't output "the" answer — at every position it holds a full probability distribution over the vocabulary; generation is one sample (or the argmax) from it | Epistemic Fork (§6): fork exactly when the distribution over candidate themes is flat, not when it "feels" tied |
| **Pointwise Mutual Information (PMI)** | `PMI(word, context) = log P(word\|context) − log P(word)` — how much more likely a word becomes *because of* this specific context, vs. its base rate | A computable version of the Distinctiveness Test (§4) |
| **Recursive / hierarchical summarization** | Long-context pipelines don't predict over the whole document at once — they chunk, get local next-token-predicted summaries per chunk, then re-run prediction over the set of local summaries, recursively, until it stops changing | An automatable version of Ladder Levels 0→2 (§3) — run as an actual chunk → local-candidate → merge → repeat pipeline instead of by hand |
| **Layered abstraction inside the model ("logit lens")** | Projecting a transformer's intermediate hidden states through its own output layer shows predictions get more abstract the deeper into the network you look — early layers predict surface continuations, later layers predict increasingly conceptual ones | Evidence that progressive abstraction-through-depth is a real property of how these models organize meaning, not just a metaphor borrowed for the Ladder |

### 13.2 Practical caveat: Claude's API doesn't expose raw logprobs

True PMI scoring needs `log P(token | context)` directly. As of this writing, Anthropic's Messages API has no `logprobs`/`top_logprobs` field — unlike some other providers' chat-completion APIs, which do expose this. So literal per-token log-probabilities aren't pullable from Claude today. Two ways around that:

- **Approximate it empirically by sampling.** Call the model N times (N ≈ 20–50) at temperature ≈ 0.8–1.0 with a tightly constrained prompt ("Respond with exactly one word: the core theme of this project is ___"), and tally the frequency of each returned word. Frequency-across-samples is a Monte Carlo estimate of the underlying probability — noisier than true logprobs, but fully computable with the Claude API today, no special access needed.
- **Use a provider whose API exposes logprobs directly**, if you specifically want the exact log-probability rather than an empirical estimate.

The procedure below assumes the sampling-based approximation, since it's what's actually runnable end-to-end right now.

### 13.3 The scoring procedure

```
1. CONDITIONED SAMPLING
   Prompt the model N times with the full project description (post
   Level-2 ablation) + "Respond with exactly one word: the theme is ___"
   at temperature ≈ 0.9. Record the returned word each time.
   → empirical distribution P_hat(word | project)

2. BASELINE SAMPLING
   Repeat step 1, but replace the project description with a maximally
   generic stand-in ("a piece of software that helps users accomplish
   a task"). → empirical distribution P_hat(word)  [unconditional base rate]

3. PMI SCORE  (Distinctiveness, quantified)
   For every word w that appeared in step 1:
       PMI(w) ≈ log( P_hat(w | project) / P_hat(w) )
   Rank candidates by PMI, not raw frequency — this is what stops a
   generic-but-frequent word ("system," "tool," "platform") from winning
   just because it's a common completion for almost anything.

4. ENTROPY SCORE  (Fork trigger, quantified)
       H = − Σ P_hat(w | project) · log P_hat(w | project)
   High H (mass spread across several distinct words) → Epistemic Fork:
   report the top candidates, don't force one.
   Low H (one word dominates) → commit to the top-PMI word.

5. CROSS-CHECK AGAINST THE LADDER
   The word(s) surviving steps 3–4 still need Reconstruction, Portability,
   and Collapse (§4) run by hand against the real feature inventory.
   Distributional scoring only ever replaces the Distinctiveness test and
   the Fork-trigger judgment call — it has no access to your actual
   feature list, so it can't validate the other three tests on its own.
```

### 13.4 Why this is a complement, not a replacement

The Ladder reasons from the project's *content* outward. Distributional scoring reasons from the model's *learned associations* — it tells you what a large sample of text tends to call things structurally similar to yours, a genuinely different and useful signal, but one that can be fooled by whatever's overrepresented in training data. ("AI-powered," "platform," and "solution" will show up with deceptively high raw frequency in step 1 for almost any software project — high frequency, but low PMI once you compute the baseline, and they'd fail Reconstruction outright.) That's exactly why step 5 insists on cross-checking against the hand-run battery rather than letting a single distributional score be the sole arbiter — the same founding principle as the rest of RTD (§1.3): the stopping point is a test battery, not a single number, however that number was produced.
