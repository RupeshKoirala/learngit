# Solution

```bash
git switch main                       # can't delete the branch you're on

git branch --merged main
#   feature/old-promo-banner
#   feature/search
#   fix/typo-footer
# * main
#   release/1.0                       <- merged, but long-lived: keep
git branch --no-merged main
#   feature/checkout-redesign         <- alive: keep
#   spike/graphql-experiment          <- abandoned: force-delete

git branch -d feature/search fix/typo-footer feature/old-promo-banner
git branch -d spike/graphql-experiment
# error: The branch 'spike/graphql-experiment' is not fully merged.
git branch -D spike/graphql-experiment          # deliberate: the team decided to drop it

git push origin --delete feature/search fix/typo-footer
git fetch --prune                     # removes origin/feature/old-promo-banner
git branch -vv
git branch -r
```

**Why it works:** `--merged main` lists branches whose tip is reachable from `main` — deleting them loses no
commits. `-d` enforces exactly that check; `-D` skips it, so use it only when you *mean* "throw these commits
away". Local branches, remote branches and remote-tracking refs (`origin/x`) are three separate things:
`git branch -d` removes the first, `git push origin --delete` the second, and `git fetch --prune` cleans up the
third when the server no longer has the branch (that's what `[gone]` in `-vv` means).

**Real-world notes**
- `release/*`, `main`, `develop` are "merged" most of the time — never feed `--merged` blindly into a delete.
  A safe one-liner:
  `git branch --merged main | grep -vE '^\*|^\s*(main|release/)' | xargs git branch -d`
- **Squash-merged** or **rebase-merged** PRs show up as `--no-merged`, because the commits on `main` are new
  copies. Check with `git log main --grep '<PR title>'` or `git diff main...branch`, then `-D` with confidence.
  `[gone]` in `git branch -vv` (after a prune) is often the best hint that the PR was merged on GitHub.
- Turn on **Automatically delete head branches** in the GitHub repo settings and `fetch.prune=true` locally;
  the junk drawer mostly cleans itself.
- Force-deleted by mistake? The commits are still in the reflog for a while:
  `git reflog` → `git branch <name> <hash>`.
- As a lead: stale branches on the server hide real work. A monthly `git branch -r --merged origin/main` review
  (or a scheduled bot) keeps the repo navigable for everyone.
