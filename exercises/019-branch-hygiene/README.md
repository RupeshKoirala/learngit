# Branch hygiene: delete what's merged, keep what's alive

`git branch` on your laptop has become a junk drawer. Maya's rule for the team: *"If it's merged, delete it —
locally and on GitHub. If it's not merged, it's either alive or it's an explicit decision to throw it away."*

```
$ git branch -vv
  feature/checkout-redesign  [origin/feature/checkout-redesign]   WIP: checkout steps
  feature/old-promo-banner   [origin/feature/old-promo-banner]    Add spring promo banner
* feature/search             [origin/feature/search]              Document search
  fix/typo-footer            [origin/fix/typo-footer]             Fix typo in footer
  main                       [origin/main]                        Fix typo in footer
  release/1.0                [origin/release/1.0]                 Add removeItem to cart
  spike/graphql-experiment                                         WIP resolvers
```

What you know:
- `feature/search`, `fix/typo-footer` and `feature/old-promo-banner` were merged into `main`.
- `spike/graphql-experiment` was never merged. The team decided in the retro to **abandon** it.
- `feature/checkout-redesign` is your current work in progress. **Keep it.**
- `release/1.0` is a long-lived release branch used for hotfixes. It shows up as "merged" — **keep it** anyway.

## Your task

1. Use `git branch --merged main` and `git branch --no-merged main` to confirm the list above.
2. Delete the three merged branches **locally** with the safe delete (`-d`).
3. Force-delete (`-D`) **only** the abandoned `spike/graphql-experiment`.
4. Delete `feature/search` and `fix/typo-footer` **on origin** too.
5. Prune stale remote-tracking refs, so no `origin/…` ref remains for branches that no longer exist on origin.
   (`feature/old-promo-banner` was auto-deleted on GitHub months ago, but your `origin/feature/old-promo-banner`
   ref doesn't know that yet — `git branch -vv` will show it as `gone` only after a prune.)
6. Keep `main`, `release/1.0` and `feature/checkout-redesign` — locally and on origin, unchanged. End on `main`.

## You'll practice

`git branch --merged` / `--no-merged`, `git branch -d` vs `-D`, why you can't delete the branch you're on,
`git push origin --delete`, `git fetch --prune`, and reading `[gone]` in `git branch -vv`.
