`-u` is short for `--set-upstream`: `git push -u origin <branch>` pushes and records the upstream. For a branch
whose remote counterpart already exists, `git branch -u origin/<branch> <branch>` sets the upstream without
talking to the network at all.
---
Once the upstream is set, `git branch -vv` prints `[origin/hotfix/tax-rounding: behind N]`. Exact count:
`git rev-list --count hotfix/tax-rounding..hotfix/tax-rounding@{u}`. To catch up: switch to it and run
`git merge --ff-only @{u}` (or `git pull --ff-only`).
---
`git branch --unset-upstream experiment/search-ranking`. For step 4: `git config push.autoSetupRemote true`
(no `--global` — this exercise checks the repo's own config), then `git switch chore/update-deps` and `git push`.
---
Your Git is older than 2.37? The setting is ignored; push with `git push -u origin chore/update-deps` instead —
the check accepts it as long as the config is set and the upstream exists.
