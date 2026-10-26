# Merge commit vs squash vs rebase

GitHub's green button has three modes, and teams argue about them. Settle it with evidence: three teammates
each pushed a small branch with **2 commits** to your lab.

```
origin/demo/merge-commit   Dev:  Add wishlist module, Export wishlist helpers
origin/demo/squash         Lena: Add product reviews, fix typo
origin/demo/rebase         Maya: Add product search, Search is case-insensitive
```

## Your task

1. Open a PR for each branch (into `main`) and merge them with **different methods**:
   - `demo/merge-commit` -> **Create a merge commit**
   - `demo/squash` -> **Squash and merge**
   - `demo/rebase` -> **Rebase and merge**
2. Pull `main` locally (local `main` must equal GitHub's `main`) and study `git log --graph --oneline main`.
   Which method kept Lena's "fix typo"? Which created commits that weren't on the branch?
3. Make the team decision a repo setting, Brightcart-style: **disable merge commits**, keep **squash**
   enabled (rebase is your call), and turn on **automatically delete head branches**.

> If you already protected `main` with "require linear history" (exercise 106), GitHub will refuse the merge
> commit: temporarily untick it, or do this exercise first.

## You'll practice

`gh pr create --head`, `gh pr merge --merge | --squash | --rebase`, `git log --graph`, `gh repo edit
--enable-merge-commit=false --delete-branch-on-merge`, and choosing a merge policy for a team.
