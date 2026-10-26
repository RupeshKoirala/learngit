# Evict a 20 MB video from history to slim every clone

Jo, on their second week, committed a 20 MB promo video into `assets/`. Two commits later they "deleted" it.
Months on, the CI pipeline still spends 40 seconds cloning, and the new hire asks why a tiny storefront repo
weighs 20 MB. The file isn't in any current checkout — it's in **history**, and every `git clone` downloads
all of history.

```
* Note currency TODO                       <- main, origin/main
| * Start gift cards                       <- feature/gift-cards
|/
* Document assets
* Lazy-load hero image
* Remove promo video (served from CDN now)  <- deletes it… but the blob is still in history
* Plan cart v2
* Add homepage hero                        <- adds assets/promo-video.mov (20 MB) + hero.png + home.js
* Initial storefront
```

Measure it first: `git count-objects -vH` (look at `size-pack`).

## Your task

In `repo` (remote `origin` is `../remotes/origin.git`):

1. Remove `assets/promo-video.mov` from **every commit on every branch**. Everything else stays: `assets/hero.png`,
   `src/home.js`, all other commits and both branches.
2. Make your local repository actually small: `size-pack` + loose objects under **2 MiB**.
3. Stop it happening again: `.gitignore` on `main` ignores `*.mov` files.
4. Restore the `origin` remote and force-push both branches. No blob bigger than 1 MB may be reachable from any
   ref on origin.
5. Finish on `main` with a clean working tree.

## You'll practice

Finding big blobs (`git rev-list --objects --all` + `git cat-file --batch-check`), `git filter-repo --path …
--invert-paths` or `--strip-blobs-bigger-than`, `git count-objects -vH`, and why Git LFS exists.
