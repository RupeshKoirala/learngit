# Solution

```bash
git switch feature/discount-codes
git log --oneline main..HEAD          # the 6 commits you'll rewrite
git rebase -i main
```

Edit the todo list to:

```
reword a1b2c3d wip
fixup  e4f5a6b wip 2
fixup  c7d8e9f fix rounding lol
fixup  1a2b3c4 oops forgot export? no. debug line
fixup  5d6e7f8 remove debug
pick   9a0b1c2 Document discount codes
```

Save and close. When the reword editor opens, replace `wip` with `Add discount code support`.

```bash
git log --oneline main..HEAD
# 2222222 Document discount codes
# 1111111 Add discount code support
git diff ORIG_HEAD HEAD               # empty: the code is identical, only history changed
```

**Why it works:** `rebase -i main` replays your branch's commits on top of `main` one by one, following the
todo list. `fixup` folds a commit into the previous one, so five code commits become one. Moving the docs
commit to the end is safe because it touches a different file.

**Real-world notes**
- Only rewrite commits nobody else has based work on. If you'd already pushed, you'd need
  `git push --force-with-lease` afterwards — fine on your own feature branch, never on `main`.
- Next time, commit with `git commit --fixup <hash>` and let `git rebase -i --autosquash main` arrange the
  todo list for you (exercise 025).
- Many teams just use GitHub's **Squash and merge** button instead. That's fine for small PRs; for big ones,
  a few meaningful commits review better than one giant one.
