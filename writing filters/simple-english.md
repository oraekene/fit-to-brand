# Simple-English filter — user-shown text only

Adapted from AminBlg/SimpleEnglish (MIT; agent skill for ASD-STE100 plain
English, v2.0.1). Only its public rules are used here. Full ASD compliance
needs the official copyrighted dictionary, so this file pairs the public
rules with our own term map below, and every question gets the CHECK pass
before it ships.

## Scope

Applies to everything a user reads: questions, ask-lists, status and error
lines, user reports. Never touches code, identifiers, saved values, keys,
or file paths. Saved answer values (`phased`, `GRP-01`) live in code
comments and hook scripts, never in prose the user sees.

## Plain base (document rules)

1. Procedural text: imperative mood, at most 20 words per sentence, one
   instruction per sentence. Descriptive text: simple tenses, at most 25
   words per sentence, one topic per paragraph.
2. Condition before command, with a comma.
3. Simple tenses, active voice. Name the actor.
4. Modals allowed: can, will, must. Never should, would, may, might, could.
5. Complete grammar. No contractions. Keep articles and keep that.
6. No semicolons and no em-dashes. Write two sentences instead.
7. One word, one meaning, for the whole document.
8. Format for the eye, not for decoration. No bold lead-ins. A vertical
   list holds three or more parallel items or steps, with a colon on the
   lead-in and one instruction per item.
9. Warnings: command or condition first, then the risk.
10. State the fact, not its importance. Delete leverage, robust, crucial,
    seamless, and their kin. No decorative triplets.

## Strict layer (dictionary discipline)

1. No internal term reaches the user. Each one is replaced by plain words,
   or explained in a full plain sentence. Length is no excuse.
2. Banned verbs (use the approved word): check, verify, confirm, ensure →
   make sure that (a state), examine (look for faults), measure (get a
   value). validate → make sure that. run, execute → do, operate only
   where the actor runs a command. display, render, present (verbs) → show.
   perform → do. repeat → do again. Need to, have to → imperative.
3. Banned fillers: however → but. therefore → thus. since (= because) →
   because. any → delete or restructure. now → delete. acceptable →
   permitted, or give the limit.
4. test, check, work are nouns only. help is a verb only.
5. One spelling, American. No phrasal verbs where one word does the job.

## Domain-to-plain map (v1 — grows with each rewritten question)

phase → step. elicitation, Q-set, ask-list → questions. artifact → result.
overlay → market setup (per-question sentences carry the detail). run-mode
→ scope. single → one product. category → whole category. wedge → winning
difference. brief → message. thread → placed message. Anchor → locked
design. Brand Lock → final visual check. gate → checkpoint. H1 → automatic
checks. H2 → quality review. H3 → your approval. claims → promises.
claims registry → promise list. NOT-fit → no-go list. kill → stop.
reposition → change direction. quota → size limit. SKU → product version.
module → chapter. verdict → decision. audit → review. hooks → automatic
checks. Generation Plan → work plan. confusion probe → mix-up test. recall
probe → memory test. CTA → the ask. motion PLG → self-serve. motion
enterprise → sales-led. trademark, domain, handle checks → name checks.
ID codes (S-0001, GRP-01, PRED-01) → never shown; use the names instead.
Log and state files (PARAMS, GATES, STATE, SOURCES, spec-sha) → never shown.
Question numbers (Q0.0) stay: they are the stable handles users answer with.

## CHECK pass (every rewritten question, before it ships)

1. Scan against the map: no internal term left in user prose.
2. Count words in the three longest sentences: split over 20 (instruction)
   or 25 (description).
3. Search: `'`, `has been`, `should`, `would`, `may`, `might`, `could`,
   `;`, `—`, `, making`, `check`, `verify`, `confirm`, `ensure`,
   `validate`, `leverage`, `robust`, `seamless`, `however`, `any `,
   `now `. Fix each hit.
4. Condition before command. Warnings command-first.
5. Machine suite green (prompts feed Enter-Phase ask-lists; wording edits
   must not break the locks).
