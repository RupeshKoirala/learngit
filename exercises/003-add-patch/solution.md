# Solution

```bash
git diff src/cart.js               # three hunks: debug line, total() fix, clearCart
git add -p src/cart.js
#   Stage this hunk (console.log)?  n
#   Stage this hunk (total fix)?    y
#   Stage this hunk (clearCart)?    n
git diff --staged                  # review exactly what goes into the commit
git commit -m "Fix total for items without qty"

git add -p src/cart.js
#   console.log?  n
#   clearCart?    y
git commit -m "Add clearCart helper"

git diff                           # only the console.log line remains, unstaged
git log --oneline -p -2            # review both commits
```

**Why it works:** the staging area doesn't hold *files*, it holds *content*. `git add -p` copies selected
hunks of the working-tree file into the index, so the index can hold a version of `cart.js` that never
existed on disk: "last commit + just the fix". `git commit` snapshots that version. The rest stays as
unstaged changes in your working tree.

Patch-mode keys worth knowing: `y`/`n` stage or skip, `s` splits a hunk at unchanged lines, `e` opens the
hunk in your editor so you can drop individual `+` lines, `a`/`d` stage or skip the rest of the file,
`/` searches for a hunk, `q` quits.

**Real-world notes**
- `git add -p` is the single habit that most improves commit quality. Many senior devs never use
  `git add .` during feature work; they review every hunk as they stage it — a free self-review.
- `-p` works on lots of commands: `git restore -p` (discard hunks), `git restore --staged -p` (unstage
  hunks), `git stash -p`, `git checkout -p`, `git reset -p`.
- A hunk staged with `e` is code that was **never run or tested** in that exact form. If you split
  aggressively, run the tests per commit (`git rebase -x ./test.sh main`) or at least before pushing.
- Debug lines like this belong in a breakpoint or a local stash, not in a commit — but if you keep them
  around, `git add -p` is how you avoid shipping them. GUI tools (VS Code, Fork, GitKraken, `lazygit`,
  `tig`) do the same thing with "stage selected lines".
