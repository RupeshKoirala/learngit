# Solution

```bash
git fsck --no-reflogs --unreachable
# unreachable blob   …
# unreachable commit 8a9b0c1…
# unreachable commit 2d3e4f5…
# unreachable commit 6a7b8c9…
# …

git log --no-walk --format='%h %s' $(git fsck --no-reflogs --unreachable | awk '/commit/ {print $3}')
# 8a9b0c1 On main: express checkout button        <- this one
# 2d3e4f5 index on main: 3f4a5b6 Update README
# 6a7b8c9 On main: experiment: dark mode
# 1c2d3e4 index on main: 3f4a5b6 Update README
# 0e1f2a3 Update README                            <- the pre-amend commit, noise

git stash show -p 8a9b0c1        # confirm: expressCheckout + src/express.js
git stash apply 8a9b0c1
git status
```

(`git fsck --lost-found` does the same search for *dangling* objects and saves them under
`.git/lost-found/commit/` — handy when you just want the list. Its output says "dangling commit".)

**Why it works:** `git stash` creates real commits: a **W** commit (your working tree, subject
`On main: <message>`) whose parents are `HEAD` and an **I** commit (`index on main: …`, your staged state),
plus a third one for untracked files with `-u`. `refs/stash` and its reflog point at W. `stash clear`/`drop`
only delete those references; the commits stay in `.git/objects` as unreachable objects until `git gc`
prunes them (by default only once they're older than 2 weeks — `gc.pruneExpire`). `--no-reflogs` matters:
without it, fsck treats commits mentioned in any reflog as reachable and might hide candidates.
`git stash apply` accepts any stash-shaped commit, not just `stash@{n}`.

**Real-world notes**
- Know the difference between *dangling* (nothing points to it — the stash W commit) and *unreachable* (not
  reachable from refs — includes the I commit, which W still points to). Look at dangling/unreachable
  **commits**; blobs are individual file versions, a last resort for lost staged changes.
- Recover fast. Don't run `git gc` (or anything that triggers `gc --auto`, like big fetches) while you're
  hunting — a prune would make the loss permanent.
- Stashes are a poor place for real work: they're local, invisible in PRs, and easy to clear. For anything
  over an hour, commit to a WIP branch (`git switch -c wip/express && git commit -am wip`) and push it.
- Name your stashes (`git stash push -m "…"`). Unnamed stashes all look like `WIP on main: <last commit>`,
  which makes this hunt much harder.
