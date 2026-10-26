# Rebase a branch that contains merges (--rebase-merges)

Your `feature/promo-banner` branch contains a **merge**: Lena built the banner themes as a separate sub-PR
against your branch, Maya reviewed it on its own, and you merged it in with a real merge commit. Now `main` has
moved and you need to rebase:

```
* Rotate banner messages every 8 seconds          <- feature/promo-banner
*   Merge branch 'banner-styles' into feature/promo-banner
|\
| * Add dark-mode banner theme                    (Lena)
| * Add banner color themes                       (Lena)
* | Add close button to banner
|/
* Add promo banner component
| * Add removeItem to cart                        <- main
|/
* Initial storefront
```

The team wants to keep that merge: it records that the themes were reviewed and integrated as one unit, and
the release tooling lists merged sub-PRs. A plain `git rebase` **flattens** merges — it silently drops the
merge commit and lines everything up.

## Your task

1. **See the default first.** Create a branch `flat/promo-banner` from the current feature tip and rebase *it*
   onto `main` the plain way. It should end up with 5 commits and no merge.
2. **Keep the shape.** Rebase `feature/promo-banner` onto `main` so the merge survives:
   - `main` + exactly 6 commits, exactly one of them the merge, with its original message.
   - Lena's 2 commits are still on the merge's side branch (the merge's second parent), rebased onto main too.
3. Both branches end with identical files, and your files are exactly as before.

`main` doesn't change. Clean tree, no rebase in progress.

## You'll practice

`git rebase --rebase-merges` (`-r`), the `label` / `reset` / `merge -C` commands in its todo list, how a
plain rebase linearises history, and judging when topology is worth keeping.
