# Solution

```bash
git diff --staged --name-only            # src/cart.js, src/price.js     (index vs HEAD)
git diff --name-only                     # README.md,   src/price.js     (working tree vs index)
# q1 = src/price.js — it's in both lists

git diff --word-diff README.md
# Orders over $50 ship free within the [-continental-]{+contiguous+} US; ...
# q2 = contiguous

git diff --stat main feature/gift-cards      # 5 files — includes main's own newer changes, reversed!
git diff --stat main...feature/gift-cards    # 3 files — only what the branch did
# q3 = 3

git diff --numstat v1.0 v1.1 -- src/cart.js
# 11  1  src/cart.js
# q4 = 11
```

`../ANSWER`:
```
q1=src/price.js
q2=contiguous
q3=3
q4=11
```

**Why it works:** every `git diff` compares two snapshots:

| Command | Left side | Right side |
|---|---|---|
| `git diff` | staging area | working tree |
| `git diff --staged` | `HEAD` | staging area |
| `git diff HEAD` | `HEAD` | working tree (everything uncommitted) |
| `git diff A B` (= `A..B`) | commit A | commit B |
| `git diff A...B` | `merge-base(A, B)` | commit B |

`price.js` was staged, then edited again — so it has a staged version *and* a newer working version. That's
also why `git commit` would only commit the first edit. Two-dot diffs between diverged branches mix in
"what the other side did meanwhile", shown reversed; three-dot diffs answer "what does this branch add?",
which is what GitHub shows in a PR. (Careful: for `git log` the meanings of `..` and `...` are different —
see exercise 008.)

**Real-world notes**
- Review your own PR with `git diff main...HEAD --stat` before requesting review. Surprise files in the
  list (lockfiles, generated code, a stray `console.log`) are the most common review comments.
- `--word-diff` / `--color-words` shine for prose: docs, translations, config values, SQL. For moved code,
  try `git diff --color-moved` so moves don't look like delete + add.
- `-w` (ignore whitespace) cuts reformatting noise during review; GitHub has the same toggle ("Hide
  whitespace").
- `git diff --check` flags trailing whitespace and conflict markers — a cheap pre-commit habit.
- Configure a better pager like `delta` or `diff-so-fancy` (`core.pager`) for side-by-side, syntax-highlighted
  diffs in the terminal.
