# "You have divergent branches": merge, rebase or ff-only?

Since Git 2.27, a `git pull` on a branch where both you and the server have new commits stops with:

```
hint: You have divergent branches and need to specify how to reconcile them.
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
fatal: Need to specify how to reconcile divergent branches.
```

There is no single right answer — it depends on the branch. Your clone has three branches that are behind:

| branch | your local commits | new on the server | |
|---|---|---|---|
| `main` | none | 2 commits (Dev) | you never commit to main directly |
| `feature/reviews` | 2, **not pushed** | 1 commit (Lena) | your PR branch, Lena helps out |
| `release/2.5` | 1: `Bump version to 2.5.1` | 1 hotfix (Dev) | QA already tested *your exact commit*: tag `v2.5.1-rc1`, pushed |

## Your task

Fetch first and look at each branch (`git log --oneline --graph --all`, `git status`). Then:

1. `main`: update it **fast-forward only**.
2. `feature/reviews`: integrate Lena's commit so your two commits sit **on top** of it — linear, no merge
   commit — and push.
3. `release/2.5`: integrate Dev's hotfix **without rewriting** your tagged commit (the tag `v2.5.1-rc1` must
   stay on the branch's history, unchanged), and push.
4. Make it the default for this repository: `git pull` should **rebase** in general, but **merge** on
   `release/2.5`. Use repo-level config (not `--global`).

Leave the working tree clean.

## You'll practice

`git pull --ff-only / --rebase / --no-rebase`, `pull.rebase`, `pull.ff`, per-branch `branch.<name>.rebase`,
and the rule of thumb: *rebase what's yours and unpublished, merge what others have already seen*.
