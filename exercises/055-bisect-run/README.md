# git bisect run: let a script find the bug in 200 commits

The finance dashboard shows `$19.09` for a `$19.99` gift card. The price CLI `bin/price` formats cents as
dollars, and its unit tests fail on `main`:

```
$ sh test/run.sh
FAIL: price 1999 -> $19.09 (want $19.99)
```

At tag `v2.0` the tests pass. Since then the team has landed **200 commits**. Checking by hand at ~8 steps is
doable but boring, and boring means mistakes. Make Git do it: **`git bisect run <command>`** checks out each
candidate, runs your command, and reads its exit code.

There's a catch. Somewhere in the middle, a few commits are a half-finished refactor where `bin/price`
**doesn't exist at all**. The tests fail there too, but not because of *this* bug. If you count those as
"bad", bisect blames the wrong commit, with full confidence.

```
* (main) ... 200 commits ...
* ...
* WIP: move price formatter to lib/ (build broken)     <- somewhere in here, untestable
* ...
* (tag: v2.0) Initial storefront with price CLI
```

## Your task

1. Write a small test script, e.g. `../bisect-test.sh` next to the repo (outside it, so checking out old
   commits can't change or delete it), that tells bisect:
   - exit **0** → good (tests pass),
   - exit **1** → bad (tests fail),
   - exit **125** → *skip*, "can't test this commit" (when `bin/price` is missing).
2. Run `git bisect run` with it between `v2.0` (good) and `main` (bad).
3. Tag the real first bad commit as **`first-bad`**.
4. Leave bisect cleanly with `git bisect reset`: no bisect in progress, back on `main`, no commits changed.

## You'll practice

`git bisect start <bad> <good>`, `git bisect run`, the exit-code contract (0 / 1–127 / **125** = skip),
`git bisect skip`, `git bisect log`, and `git bisect reset`.
