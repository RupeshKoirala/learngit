# Solution

```bash
git status -s
# Output:
# M  src/cart.js      <- left column = staged, right column = unstaged
#  M README.md
# M  src/price.js
# ?? notes.txt

git restore --staged src/cart.js       # take cart.js out of the next commit (edits stay on disk)
git diff --staged --stat               # now only src/price.js is staged
git commit -m "Fix rounding in formatPrice"

git add src/cart.js README.md
git diff --staged --stat               # exactly the feature, nothing else
git commit -m "Add removeItem to cart"

git log --oneline --stat -2
git status -s                          # ?? notes.txt — and nothing else
```

**Why it works:** Git has three places your code can be:

| Area | What it is | Moves there with |
|---|---|---|
| Working tree | the files on disk | your editor |
| Staging area (index) | a draft of the next commit | `git add`, back out with `git restore --staged` |
| Repository | permanent snapshots | `git commit` |

`git commit` snapshots the **staging area**, not your folder. That's why you can have a messy working tree
and still make precise, focused commits. `git restore --staged <file>` copies the file's version from the
last commit back into the index; your working copy is untouched.

**Real-world notes**
- "One logical change per commit" is what makes `git revert`, `git cherry-pick` and `git bisect` useful.
  A fix that's tangled with a feature can't be shipped as a hotfix on its own.
- Read `git diff --staged` before every commit. Senior engineers do this habitually — it catches debug
  lines, secrets and stray files before they become history.
- `git status -s` is the fast view: first column = staged, second = unstaged, `??` = untracked.
- Keep personal scratch files out of the repo without touching the shared `.gitignore`: add them to
  `.git/info/exclude` (this repo only) or a global excludes file (`git config --global core.excludesFile`).
- `git commit -a` stages modified *tracked* files automatically — handy, but it's exactly how unrelated
  changes end up in one commit. Use it only when `git status` shows one coherent change.
