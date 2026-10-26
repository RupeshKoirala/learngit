# Undo an unpushed merge; abort a half-resolved one

Busy morning on `main`. You merged Dev's search branch locally (not pushed yet), started writing a README
note about it (not committed), and then began merging Lena's sorting branch. That one conflicted in two
files; you resolved `src/price.js` and staged it, and you're halfway through `src/cart.js` when Maya pings:

> "Don't merge either of those yet! Search needs a security review and sorting depends on it. Put `main`
> back the way it is on origin — but keep the branches, we'll merge them via PRs next week."

```
$ git status --short
 M README.md          <- your note: keep it!
UU src/cart.js        <- still conflicted
M  src/price.js       <- resolved & staged

  (merge of feature/sort-by-price in progress)
*   Merge branch 'feature/search'       <- main (local only)
|\
| * Add product search                  <- feature/search
|/
* Round totals and prefix prices…       <- origin/main
```

## Your task

1. Get out of the in-progress `feature/sort-by-price` merge, discarding your half-done resolution.
2. Undo the local `feature/search` merge, so `main` is exactly `origin/main` again — and `src/search.js` is
   gone from your working tree.
3. **Keep your uncommitted README note** (still uncommitted). It should be the only change `git status`
   shows.
4. Keep both feature branches where they are; push nothing.

⚠️ Think before you reach for `ORIG_HEAD` — check what it points at *after* step 1.

## You'll practice

`git merge --abort`, `git reset --merge`, `ORIG_HEAD` and why it changes under you, `HEAD~1` vs `HEAD^2` on a
merge commit, and undoing things without trampling uncommitted work (`--merge`/`--keep` vs `--hard`).
