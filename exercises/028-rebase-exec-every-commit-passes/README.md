# Make every commit pass the tests with rebase -x

`feature/loyalty` is green in CI — the tip passes `./test.sh`. But Brightcart merges PRs with **Rebase and
merge**, so every one of your commits lands on `main` individually, and the team relies on `git bisect` and
on being able to deploy or revert any commit. Maya's rule: **every commit must pass the tests**, not just the
last one.

```
* Export loyalty helpers              <- feature/loyalty   (tests pass here)
* Award loyalty points at checkout
* Add loyalty points calculator
* Add loyalty tier names
* Initial storefront                  <- main
```

One of these commits broke the tests and a later one quietly repaired them.

## Your task

1. Run the test suite against **every** commit of the branch with one rebase command and find the **first**
   commit that fails. Write its hash (the hash it has *now*, before you change anything) into the file
   `ANSWER` in the sandbox folder (one level above `repo/`), e.g. `git rev-parse HEAD > ../ANSWER` while the
   rebase is stopped there.
2. Fix the history so every commit passes: the repair belongs **in the commit that broke things**. The
   branch ends with exactly 3 commits: `Add loyalty tier names`, `Add loyalty points calculator`,
   `Award loyalty points at checkout` — and the final files are exactly what you have now.

`main` doesn't change. Clean tree, no rebase in progress.

## You'll practice

`git rebase -x <cmd>` (`--exec`), what happens when an `exec` line fails, combining `exec` with reordering
and `fixup` in an interactive todo list, and why "every commit is green" matters for `bisect` and rebase-merge.
