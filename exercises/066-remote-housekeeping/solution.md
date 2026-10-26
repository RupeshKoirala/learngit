# Solution

```bash
# 1 + 2. prune stale refs, delete merged local branches whose upstream is gone
git fetch --prune
git branch -vv                                  # feature/gift-cards [origin/feature/gift-cards: gone]
git branch -d feature/gift-cards

# 3. delete a branch on the server
git push origin --delete spike/old-checkout

# 4. master -> main
git branch -m master main
git push -u origin main                         # create main on the server, track it
git --git-dir=../remotes/origin.git symbolic-ref HEAD refs/heads/main   # = GitHub "Default branch" setting
git push origin --delete master
git fetch --prune                               # drops origin/master
git remote set-head origin --auto               # origin/HEAD -> origin/main
git branch -a -vv
```

**Why it works:** remote-tracking refs are a local cache; `fetch` adds and updates them but only deletes them
when asked (`--prune`). Branches on the server are deleted by pushing an empty value to them. A rename on the
server is really *create main + delete master*, and the server's `HEAD` is what decides the default branch new
clones check out — that's why it must be switched before `master` disappears. `origin/HEAD` in your clone is a
copy of the server's HEAD made at clone time; it never updates on its own, so `set-head --auto` re-reads it.

**Real-world notes**
- Turn pruning on for good: `git config --global fetch.prune true` (and `fetch.pruneTags true` if your team
  deletes tags).
- Bulk-delete local branches whose upstream is gone:
  `git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d` (use `-d`, not `-D`, so unmerged work is safe).
- GitHub's rename button (Settings → Branches) does more than plain Git: it re-targets open PRs, branch protection
  rules and redirects web links. Check CI configs, deploy pipelines, badges and scripts for hard-coded `master`.
- Teammates then run what GitHub shows them:
  `git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a`.
- Announce renames and deletions ahead of time; a PM-friendly change log entry avoids "my branch vanished" tickets.
  Enable "Automatically delete head branches" so merged PR branches clean themselves up.
