# Remote housekeeping: prune, delete, rename master to main

Maya (tech lead) wants to tidy up the repository before new hires join:

> 1. Our default branch is still called `master`. Let's rename it to `main` on the server.
> 2. Please clean up your old branches while you're at it.

Your clone is cluttered. `git branch -a -vv` shows things like:

```
  feature/gift-cards      a12… [origin/feature/gift-cards] Add gift card redemption
* master                  f00… [origin/master] Merge pull request #13 from fix/old-tax
  remotes/origin/HEAD     -> origin/master
  remotes/origin/feature/gift-cards    <- deleted on the server after PR #12 was merged
  remotes/origin/fix/old-tax           <- deleted on the server after PR #13 was merged
  remotes/origin/master
  remotes/origin/spike/old-checkout    <- your abandoned spike, still on the server
```

A plain `git fetch` never deletes `origin/*` refs, so branches deleted on the server live on in your clone.

## Your task

1. Remove the **stale** remote-tracking branches (`origin/feature/gift-cards`, `origin/fix/old-tax`).
2. Delete your local `feature/gift-cards` — it was merged, and its upstream is now *gone*.
3. Delete your abandoned `spike/old-checkout` branch **on the server**.
4. Rename `master` to `main`, everywhere:
   - on the server: a `main` branch with the same commit, and **no** `master` branch any more;
   - the server's **default branch** (its `HEAD`) must be `main`. On GitHub that's *Settings → Default branch*;
     here run `git --git-dir=../remotes/origin.git symbolic-ref HEAD refs/heads/main`;
   - locally: your branch is called `main` and tracks `origin/main`; no `origin/master` left, and
     `origin/HEAD` points at `origin/main`.

## You'll practice

`git fetch --prune`, `git branch -vv` ("gone"), `git branch -d`, `git push origin --delete`,
`git branch -m`, `git push -u`, `git branch -u`, `git remote set-head origin --auto`, `git remote prune`.
