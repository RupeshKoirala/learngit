# Solution

```bash
git diff src/price.js                  # last look before throwing it away
git restore src/price.js               # working tree <- last commit
git restore --staged src/cart.js       # index <- last commit; your file on disk is untouched

git clean -n -d                        # DRY RUN: lists src/coupon.js too!
git clean -n -d -e src/coupon.js       # exclude it, check again
git clean -f -d -e src/coupon.js       # delete for real

git status -s
#  M src/cart.js
# ?? src/coupon.js
```

**Why it works:**

| You want to undo… | Command | Older equivalent |
|---|---|---|
| edits in the working tree | `git restore <file>` | `git checkout -- <file>` |
| staging (keep edits) | `git restore --staged <file>` | `git reset HEAD <file>` |
| both at once | `git restore --staged --worktree <file>` | `git checkout HEAD -- <file>` |
| untracked files | `git clean -f` (`-d` folders, `-x` ignored too) | — |

`git restore` and `git switch` (Git 2.23) split the overloaded `git checkout` into two clear commands.
`git clean` only touches **untracked** files; ignored files are protected unless you pass `-x` (or `-X` for
*only* ignored). `-e <pattern>` adds an extra exclude for this run.

**Real-world notes**
- `git restore <file>` and `git clean -f` are the two commands in daily Git that **destroy work with no
  undo** — the content was never committed, so even `reflog` can't help. Pause, diff, dry-run.
- Unsure whether you'll want the experiment later? `git stash push src/price.js` (or
  `git stash -u` for untracked files) instead of discarding. A stash is cheap; regret is expensive.
- `git clean -fdx` is the "make it like a fresh clone" nuke; great on CI, painful locally when it eats
  `.env` and a 2 GB `node_modules`.
- Junk files that keep coming back (`*.orig`, `coverage/`) belong in `.gitignore` — or set
  `git config --global mergetool.keepBackup false` to stop `*.orig` files from merge tools.
