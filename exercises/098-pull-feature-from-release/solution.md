# Solution

```bash
git switch release/2.3
git log --oneline --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3   # exactly six, newest first

list=$(git log --format=%h --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)
git revert --no-commit $list                     # newest first -> no conflicts
git status                                       # staged: the combined undo of all six
git diff --cached --stat

git commit -m "Revert gift cards from 2.3 (Legal sign-off pending)" \
  -m "$(git log --format='Reverts %h %s' --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)"

git diff v2.2.0 release/2.3 --stat               # no giftcard files; everything else still there
git grep -i giftcard release/2.3                 # nothing
```

**Why it works:** `git revert` creates the inverse of a commit. `--no-commit` (`-n`) stacks several inverses
in the index and working tree so you commit them once — one commit that QA can test and that can itself be
reverted in one step. The release branch is shared, so you *add* a commit instead of dropping the six with an
interactive rebase.

**Order matters.** Each revert is a 3-way merge against the *current* state. Reverting "gift card model"
first means "delete `src/giftcards.sh` as it was when created", but the file has since been changed by three
later commits → modify/delete conflict. Reverting newest first peels the changes off in the reverse order
they were applied, so every step sees exactly the state it expects. `git log` lists newest first, so feeding
its output to `git revert` gets this right for free.

**Real-world notes**
- **The merge-back trap (important!).** When `release/2.3` is merged back into `main`, the revert commit comes
  along and **deletes gift cards from `main` too** — Git sees "release removed these lines" and applies it.
  Options: (a) right after merging back, revert the revert on `main` (`git revert <revert-commit>`) with a
  message like "Restore gift cards for 2.4", or (b) don't merge the release branch back at all and
  cherry-pick its fixes forward instead. Put this in the release checklist — it bites every team once.
- **Re-shipping in 2.4** is the same move: on the 2.4 release branch the gift cards come back automatically
  if you used option (a); otherwise revert the revert.
- **Feature flags beat reverts.** If gift cards had been behind a flag, the PM's request would be a config
  change, not a Git operation two days before release. As a lead, push for flags on anything with
  legal/compliance/marketing dependencies — those dates move.
- **Precise selection** is the whole job here: `--grep card` would have also reverted saved payment cards.
  Conventional-commit scopes (or `Feature: giftcards` trailers, or one PR per feature merged with `--no-ff`
  so you can `git revert -m 1 <merge>`) make "pull this feature" a query instead of archaeology.
- `git revert --abort` gets you out of a half-done multi-revert; `git revert --quit` forgets the sequence
  but keeps what's done.
