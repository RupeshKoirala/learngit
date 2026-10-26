Start: `git bisect start v3.1.0 v3.0.0` (bad first, then good). Then let Git drive the repro:
`git bisect run ../repro-checkout.sh`. Exit code 125 makes bisect *skip* a commit that can't be tested
(one commit in the range temporarily moved the checkout file away — if bisect lands there, it skips it).
---
Bisect prints `<hash> is the first bad commit`. Look at it with `git show <hash>` — the subject sounds
harmless, the diff isn't. Note the hash, then `git bisect reset` to go back to where you were.
---
`git switch release/3.1 && git revert <culprit>` (keep the default "Revert …" message — it records the reverted
hash). Run `../repro-checkout.sh`, then `git tag -a v3.1.1 -m "Brightcart 3.1.1 (INC-311)"`.
---
For `main`: `git switch main && git cherry-pick -x <revert-commit>` (or `git merge release/3.1`). Run the repro
again. Then write `INCIDENT.md` with `## Timeline` (bullets with times), `## Root cause` (the hash, what the
change did, why tests didn't catch it) and `## Resolution` (`v3.1.1`, the revert, follow-ups), and commit it.
