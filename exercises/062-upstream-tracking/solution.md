# Solution

```bash
git branch -vv                                          # see the four states

# 1. push and record the upstream in one go
git push -u origin feature/wishlist

# 2. set the upstream without pushing, read ahead/behind, catch up
git branch -u origin/hotfix/tax-rounding hotfix/tax-rounding
git branch -vv                                          # [origin/hotfix/tax-rounding: behind 2]
echo 2 > ../ANSWER
git switch hotfix/tax-rounding
git merge --ff-only @{u}                                # or: git pull --ff-only
git switch main

# 3. a private branch shouldn't track main
git branch --unset-upstream experiment/search-ranking

# 4. never type -u again
git config push.autoSetupRemote true                    # in real life: git config --global ...
git switch chore/update-deps
git push                                                # "branch 'chore/update-deps' set up to track 'origin/chore/update-deps'"
git branch -vv
```

**Why it works:** the upstream is just two config lines per branch — look at `.git/config`:

```
[branch "feature/wishlist"]
	remote = origin
	merge = refs/heads/feature/wishlist
```

`push -u`, `branch -u`, `switch <remote-branch>` and `push.autoSetupRemote` all write these lines;
`--unset-upstream` removes them. With them in place, `git status` / `git branch -vv` compare your branch to
`origin/<branch>` (as of your last fetch!) and report ahead/behind, `git pull` knows what to integrate, and
`git push` (with the default `push.default=simple`) knows where to push. `@{u}` is shorthand for "this branch's
upstream", e.g. `git log @{u}..` = "what will I push?" and `git log ..@{u}` = "what will I pull?".

**Real-world notes**
- `git switch -c topic origin/main` silently makes `topic` track `origin/main` — a classic source of "why did
  `git pull` merge main into my branch?". Branch from `origin/main` with `--no-track`, or set
  `git config --global branch.autoSetupMerge simple` (only tracks when the names match).
- The ahead/behind numbers are only as fresh as your last `git fetch`. "Up to date with origin/main" can be a lie
  if you haven't fetched today.
- Put `push.autoSetupRemote=true` in your global config; combined with `push.default=simple` it makes
  `git push` on a brand-new branch just work, and it never pushes to a differently-named branch.
- Deleted the remote branch after merging? `git branch -vv` shows `[origin/x: gone]` — exercise 066 cleans those up.
