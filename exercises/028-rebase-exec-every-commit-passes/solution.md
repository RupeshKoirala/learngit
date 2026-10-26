# Solution

**1. Find the first failing commit**

```bash
git rebase -x ./test.sh main
# Executing: ./test.sh
# tests passed
# Executing: ./test.sh
# tests FAILED: src/loyalty.js exports nothing, require() returns {}
# warning: execution failed: ./test.sh
# You can fix the problem, and then run
#   git rebase --continue

git log -1 --oneline            # 2222222 Add loyalty points calculator
git rev-parse HEAD > ../ANSWER
git rebase --abort
```

**2. Move the repair into the commit that needs it**

```bash
git rebase -i -x ./test.sh main
```

```
pick  1111111 Add loyalty tier names
exec  ./test.sh
pick  2222222 Add loyalty points calculator
fixup 4444444 Export loyalty helpers
exec  ./test.sh
pick  3333333 Award loyalty points at checkout
exec  ./test.sh
```

All three `exec` lines pass and the rebase finishes. `git diff ORIG_HEAD HEAD` is empty.

**Why it works:** `-x <cmd>` adds an `exec <cmd>` line after every `pick` in the todo list. If the command exits
non-zero, the rebase stops with that commit as `HEAD`, exactly like an `edit` — so you can fix it right there
(`git commit --amend`, then `git rebase --continue`) or abort and restructure. Because `main` hadn't moved,
the first run didn't rewrite anything (Git "fast-forwards" over unchanged commits), so the hash you wrote down
is the real one. In step 2 the "Export loyalty helpers" commit is the repair, so folding it into the calculator
commit makes that commit correct on its own; the checkout commit, which `require`s the helpers, now sits on a
working base too.

Alternative for step 2: stop on the broken commit with `edit`, add the `module.exports` line, `git commit
--amend`, `git rebase --continue`, and then `drop` the now-redundant "Export loyalty helpers" commit (it will
conflict or become empty).

**Real-world notes**
- Use it before every push of a multi-commit PR: `git rebase -x 'npm test' origin/main`. For a fast loop, run a
  quick subset (`-x 'npm run lint && npm run test:unit'`).
- Why it matters: `git bisect` assumes every commit is testable — a red commit in the middle sends it the wrong
  way or forces `git bisect skip`. With rebase-merge, every commit is deployable from `main`.
- CI usually tests only the PR tip (or the merge result). Some teams add a job that runs the suite on each
  commit of the PR, or require squash-merges so only the tip matters — know which your team does.
- `git rebase --exec` also works without `-i` and with `--root` (the whole history) — handy for "does every
  commit still build?" checks after a big history rewrite.
