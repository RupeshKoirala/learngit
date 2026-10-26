# Fork workflow: sync with upstream and update your PR

You contribute to Brightcart's open-source storefront from a **fork**. There are two remotes in this story:

| name | sandbox path | what it is | can you push? |
|---|---|---|---|
| `origin` | `remotes/fork.git` | your fork | yes |
| *(not added yet)* | `remotes/brightcart.git` | the company repo | **no** — changes go in via PRs |

Your PR branch `feature/size-guide` (2 commits) is on your fork. Since you forked, the company's `main` got 3
new commits, and the maintainer asks you to "rebase on the latest main". Your fork's `main` is stale too:

```
brightcart.git main:  A - B - C - D - E          your fork main / your local main:  A - B
                                                  your PR branch:                     A - B - s1 - s2
```

## Your task

1. Add the company repo as a remote named **`upstream`** and fetch it.
2. Sync your fork: make your local `main` equal to `upstream/main` (fast-forward) and push it to **your fork**
   (`origin`).
3. Rebase `feature/size-guide` onto the latest `upstream/main` (linear, still exactly 2 commits) and update the
   PR by pushing it to your fork — safely.
4. Never push anything to `upstream`. `origin` must still point at your fork.

## You'll practice

`git remote add`, `git remote -v`, `git fetch upstream`, `git merge --ff-only upstream/main`,
`git push origin main`, `git rebase upstream/main`, `git push --force-with-lease`, and why a fork's `main`
should be a pure mirror of upstream.
