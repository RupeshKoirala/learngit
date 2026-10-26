# Cherry-pick with a conflict: the code moved on main

Last night's production incident was fixed directly on `release/3.1` (the branch that's deployed). Now
those fixes must be **forward-ported** to `main`, or 3.2 will ship the same bugs again.

```
* Fix formatPrice for negative amounts      <- release/3.1   (want)
* Release 3.1.1                                              (NOT for main: version bump)
* Fix total() for items without a qty                        (want)
| * Refactor: extract lineTotal() from total()   <- main
| * Start 3.2 development
|/
* Release 3.1.0
```

Catch: while the release was being patched, Lena refactored `total()` on `main`. The qty fix was written
against the *old* code, so Git won't be able to apply it on its own.

## Your task

1. `main` gets exactly **2 new commits**, in this order: `Fix total() for items without a qty`, then
   `Fix formatPrice for negative amounts`.
2. Keep Lena's refactor: `main` must still have `lineTotal()` and `total()` must still use it — with the qty
   fix applied inside `lineTotal()` (an item without `qty` counts as 1).
3. The version bump stays off `main` (`VERSION` is still `3.2.0-dev`).
4. `release/3.1` unchanged; no conflict markers; clean tree; no cherry-pick in progress.

## You'll practice

Resolving a cherry-pick conflict by understanding the *intent* of the change, `git cherry-pick --continue`,
`--skip` (drop the commit Git is stuck on) and `--abort` (give up, back to where you started).
