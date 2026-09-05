# Simple-English filter — user-shown text only

Adapted from AminBlg/SimpleEnglish (MIT; agent skill for ASD-STE100 plain
English, v2.0.1). Only its public rules are used here. The official
dictionary (ASD-STE100 Issue 9, 2025-01-15) is free to download and use
(free at asd-ste100.org), and it is the reference for every CHECK below —
but its text is not reproduced here, because its copyright page permits use
while prohibiting reproduction and publication without ASD written
authority. This file therefore paraphrases rules and carries only our own
term map, with the official source named. The SimpleEnglish skill takes the
same position (it ships rulings, never dictionary content).

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

## Dictionary rulings applied (from Issue 9, used not reproduced)

The project copy of ASD-STE100 Issue 9 (Part 1: 53 writing rules; Part 2:
controlled dictionary) is read-only reference in the repo root. Nothing
from it is copied into this file. These paraphrased rulings drive every
rewrite:

1. check, verify, confirm, ensure as verbs → make sure that (a state),
   examine (look for faults), measure (get a value). check and test are
   nouns only (do a check, do a test). help is a verb only.
2. follow means come after only. For instructions use obey.
3. acceptable is not approved. Give the limit, or use permitted. complete
   as an adjective is not approved. Use completed.
4. option is not approved. Use alternative, or can. single is not
   approved. Use one. main is not approved. Use primary. portion is not
   approved. Use part. people is not approved. Use person or personnel.
   old is not approved. Use remaining, used, or expired.
5. run is not approved. Use operate. execute is not approved. Use do.
   perform is not approved. Use do. repeat is not approved. Use do again.
6. display, render, present as verbs are not approved. Use show.
7. avoid is not approved. Use prevent. reach is not approved. Use get.
   insert is not approved. Use put. press is not approved. Use push.
   secure is not approved. Use attach. rotate is not approved. Use turn.
   fit as a verb is not approved. Use install.
8. shall and should are not approved. Use must. may is not approved. Use
   can. need as a verb is not approved. Use necessary. have to is not
   approved. Use an action verb in command form. required is not approved.
   Use necessary. since meaning because is not approved. Use because.
   however is not approved. Use but. therefore is not approved. Use thus
   or as a result. further is not approved. Use more. now is not approved.
   Use at this time, or delete it. any is not approved. Delete it or
   restructure. over is not approved. Use above, on, or along. under is
   not approved. Use below, in, or less than. alternate is not approved.
   Use alternative. using is not approved. Use use, or with.
8. One term per item (Rule 1.11): once the map picks a plain word, that
   word is used everywhere. No synonyms beside it.
9. Noun stacks hold three words at most (Rule 2.1). Break longer ones
   with a preposition.
10. No regional, slang, or jargon terms (Rule 1.10). Our map is the
    project-local enforcement of this rule.

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
