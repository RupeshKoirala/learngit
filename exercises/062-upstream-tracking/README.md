# Upstream tracking: push -u, ahead/behind, set and unset

Every local branch can have an **upstream** — the remote branch it "belongs to". It's what makes plain
`git push`, `git pull` and the "ahead 2, behind 1" in `git status` work. Your clone has four branches in four
different states. Run `git branch -vv` and you'll see something like:

```
  chore/update-deps         3c1e…  Add eslint as a dev dependency
  experiment/search-ranking 9f2a… [origin/main: ahead 1] Try ranking search results by margin
  feature/wishlist          77b0…  Document wishlist limit
  hotfix/tax-rounding       a41d…  Round sales tax to whole cents
* main                      12ef… [origin/main] Add sales tax
```

- `feature/wishlist` — your feature, 2 commits, never pushed.
- `hotfix/tax-rounding` — you made it from a hash Lena pasted in chat, so it has no upstream, even though
  `origin/hotfix/tax-rounding` exists and Lena has pushed more since.
- `experiment/search-ranking` — a private experiment you created from `origin/main`, so Git made it *track
  origin/main*. A careless `git pull` or `git push` on it now talks to `main`.
- `chore/update-deps` — never pushed.

## Your task

1. Push `feature/wishlist` to origin **and** set its upstream in the same command.
2. Give `hotfix/tax-rounding` the upstream `origin/hotfix/tax-rounding` **without pushing**. Then read
   `git branch -vv`: write how many commits it is **behind** its upstream into `../ANSWER` (just the number).
   Then bring it up to date with Lena's work (fast-forward).
3. Remove the upstream of `experiment/search-ranking` (it stays local, don't push it).
4. Turn on `push.autoSetupRemote` **for this repository**, then push `chore/update-deps` with a plain
   `git push` (no `-u`, no remote or branch name) and confirm it got an upstream.

## You'll practice

`git push -u`, `git branch -vv`, `git branch -u / --set-upstream-to`, `git branch --unset-upstream`,
`git status` ahead/behind, `@{upstream}` / `@{u}`, and `push.autoSetupRemote` (Git 2.37+).
