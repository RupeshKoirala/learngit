# Cherry-pick a merge commit to bring a whole feature to a release

Sales closed a big wholesale customer — on the condition that the **wishlist** ships in the 2.4 line they
run, not in 2.5 months from now. Lena's wishlist PR (#42) was merged into `main` last week:

```
* Start 2.5 development                         <- main
*   Merge pull request #42 from lena/wishlist   <- the whole feature, as one merge
|\
| * Persist wishlist in localStorage            <- lena/wishlist
| * Add wishlist button to product page
| * Add wishlist model
* | Fix typo in footer
|/
* Experimental recommendations engine (behind flag)
| * Note: price locale follow-up                <- release/2.4
|/
* Release 2.4.0  (v2.4.0)
```

Careful: Lena branched **after** the experimental recommendations engine landed. Merging `lena/wishlist`
into the release would drag that half-baked engine along. And a plain `git cherry-pick <merge>` fails:
a merge has two parents, so Git doesn't know which side's diff you mean.

## Your task

1. `release/2.4` gets exactly **one new, ordinary (non-merge) commit** containing the whole wishlist feature
   — exactly what PR #42 brought into `main`, nothing more.
2. Its subject is **`Add wishlist (backport of PR #42)`**, and its message contains
   `(cherry picked from commit <full hash of the merge commit>)`.
3. No `src/recommend.js` on `release/2.4`; `main` and `lena/wishlist` unchanged.
4. Clean tree, no cherry-pick in progress.

## You'll practice

`git cherry-pick -m 1 <merge>`, what a merge commit's "mainline" parent is, `-x` and `-e` (edit the message),
and `git show --first-parent`/`git diff M^1 M` to preview what a merge brought in.
