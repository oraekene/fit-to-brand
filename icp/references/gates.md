# Gates and reconciliation

Load before starting any stage. A red gate blocks the next stage.

1. Header gate — every artifact opens with `project | run-mode | overlay | theme (broad/sharp, from S1) | model | temp | date | counts | spec-sha` (S0 additionally declares line-cap/K-rank/K-fit quotas; S3 additionally states base currency/year/PPP source). Missing header is red; missing optional platform-role is pass; undeclared quotas take defaults, silently mixed quota values are red.
2. Count gate — header `N` from S2 equals rows in S2, rows in S3, S-ID coverage in S4, (S-ID,P-ID) coverage in S5A. Any mismatch is red; fix the stage, re-run downstream.
3. ID gate — `S-0001` format, unique, sequential; `P-0001` unique; fit rows reference existing S-ID and P-ID only; `sector_tags` use registered `SEC-` keys or empty. Dangling keys are red.
4. Grammar gate (S1) — theme <=3 words with number agreement. `Decisions making`-pattern is red.
5. Format gates — S2 bulleted (comma-paragraphs red), every S2 row has >=1 substantive lens with reasons on N/A lenses; S3 $0 without flag red, subsistence row without livelihood tier + note red; S4 any `(a)/(b)` red, physical row missing unit_economics/channel/warranty_reg red, channel/certs outside the active overlay registry red, software-only verb on pure-physical P-ID red; S5A any missing landing-place or spec cite red, landing-place outside overlay terms red, category-mode self-match as `(a)` red, cert without named regime red; S5B brief count != group count red, group nouns outside overlay registry red.
6. Honesty gate — S0 Out-of-Scope empty red; S5A NOT-fit empty without written justification red; safety-critical fit without safety note red.
7. Redundancy gate — any category mapped three times (AIDE §§1-24/25-48/56-93 pattern) red; second S2 volume without explicit request red.
