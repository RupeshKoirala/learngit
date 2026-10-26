# A teammate force-pushed over your commits: recover them

Yesterday you pushed two commits to the shared `release/2.4` branch. This morning `git fetch` printed:

```
 + 4be1c0a...9d27f13 release/2.4 -> origin/release/2.4  (forced update)
```

`git status` said your branch and origin had diverged, someone in chat said *"just `git reset --hard
origin/release/2.4`"*, and you did. Now your two commits are gone from the branch — locally **and** on origin:

```
what origin had yesterday            what origin has now (Dev force-pushed)
* Changelog: sales tax   (you)       * Document shipping cache key  (Dev)
* Add CA and NY sales tax rates (you)* Cache shipping rates          (Dev)
* Cut release/2.4                    * Cut release/2.4
```

Dev had an old copy of the branch; his push was rejected, so he used `git push --force`. His two commits are
good work too. Nothing is lost yet: Git keeps a **reflog** of where your branches have been.

## Your task

1. Find your two lost commits (`Add CA and NY sales tax rates`, `Changelog: sales tax`) in your repository.
2. Restore them on `release/2.4` **on top of Dev's work** and push — with a normal push, Dev's commits must stay.
   Each of your commits should appear exactly once.
3. Your local `release/2.4` must match origin's. Leave the working tree clean. Don't touch `main`.
4. Make sure nobody can rewrite history on the shared repo again: turn on the server-side setting that **rejects
   non-fast-forward pushes** on `remotes/origin.git` (our stand-in for GitHub's branch protection).

## You'll practice

`git reflog` / `git reflog show <branch>` / `<branch>@{n}`, reading "(forced update)", `git cherry-pick A..B`,
and `receive.denyNonFastForwards` — and what a lead does after a force-push incident.
