# The stash no longer applies: recover it with git stash branch

Three weeks ago you started **loyalty points** at checkout, stashed it to handle something urgent, and
forgot about it. Sam (PM) just put loyalty points at the top of the roadmap. You find your work:

```
$ git stash list
stash@{0}: On main: experiment: dark mode
stash@{1}: On main: WIP: loyalty points in checkout

$ git stash apply stash@{1}
CONFLICT (content): Merge conflict in src/checkout.js
```

Since then Lena rewrote `checkout()` on `main`. You don't want to untangle a conflict from three-week-old
memory *in the middle of main*. Better: put the work back **exactly where it was created**, commit it on
its own branch, and deal with integrating it as a normal branch later (rebase, PR, review).

```
* Add stock check                         <- main
* Checkout: return a full order object    (rewrote checkout.js)
* Add checkout                            <- the commit your loyalty stash was made on
* Initial storefront
```

## Your task

1. Turn the loyalty stash into a new branch **`feature/loyalty-points`** that starts at the commit the
   stash was made from (`Add checkout`), with the stashed work restored.
2. Commit **all** of the stashed work (it includes a new file, `src/loyalty.js`) as one commit:
   **`Add loyalty points to checkout`**.
3. The loyalty stash must be gone from the stash list; `experiment: dark mode` must still be there.
4. `main` unchanged; clean working tree; no merge/cherry-pick in progress. (If you tried `apply` and got
   a conflict, clean that up first: `git reset --hard` — your stash is still safe.)

## You'll practice

`git stash branch <name> [<stash>]`, `git stash show` to see a stash's base commit, and recovering
from a failed `git stash apply`.
