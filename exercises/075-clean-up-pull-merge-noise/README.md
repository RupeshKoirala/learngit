# Clean up "Merge branch 'main' of origin" noise

You've been working directly on `main` all day and ran `git pull` three times to stay up to date. Your pull
was in merge mode, so each pull that found new teammate commits created a merge bubble. Run `./lg graph`:

```
* Document reviews                               <- main (not pushed)
*   Merge branch 'main' of ../remotes/origin
|\
| * Ignore dist folder                           <- origin/main (as of your last fetch)
* | Add average rating
* |   Merge branch 'main' of ../remotes/origin
|\ \
| |/
| * Clarify price currency
* | Validate review rating
* |   Merge branch 'main' of ../remotes/origin
|\ \
| |/
| * Limit cart size
* | Add product review model
|/
* Initial storefront
```

Maya's team keeps `main` linear: every commit on it should be a real change. Three "Merge branch 'main' of
origin" commits carrying zero information would get your push rejected in review. Oh — and Dev pushed another
commit a few minutes ago that you haven't fetched yet.

## Your task

1. Make your local `main` the **latest** `origin/main` plus exactly your **4 commits** on top
   (`Add product review model`, `Validate review rating`, `Add average rating`, `Document reviews`) —
   linear, **no merge commits**, each of your commits exactly once, all teammates' changes kept.
2. Push it: `origin/main` must equal your `main`.
3. So it doesn't happen again, set **this repo's** config so `git pull` rebases (`pull.rebase=true`, no `--global` —
   the checker only sees repo config; set it globally too afterwards if you like).
4. Clean working tree.

## You'll practice

`git fetch`, `git rebase origin/main` (and how it drops merge commits), `git log --graph --oneline`,
`pull.rebase`, `git pull --rebase`, and checking you didn't lose anything with `git range-diff` / `git diff`.
