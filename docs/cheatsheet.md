# Git cheat sheet (the 20% you use 80% of the time)

Set these once:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true            # rebase local work on pull instead of merge commits
git config --global push.autoSetupRemote true   # first push sets the upstream for you
git config --global rebase.autoSquash true
git config --global rebase.updateRefs true      # move stacked branches during rebase
git config --global merge.conflictStyle zdiff3  # show the common ancestor in conflicts
git config --global rerere.enabled true         # remember conflict resolutions
git config --global fetch.prune true            # drop deleted remote branches on fetch
git config --global alias.lg "log --graph --oneline --decorate --all"
```

## Everyday

| Do | Command |
|---|---|
| What's going on? | `git status -sb`, `git lg` |
| What did I change? | `git diff` (unstaged), `git diff --staged` |
| Stage pieces | `git add -p` |
| Commit | `git commit -m "feat: …"` |
| New branch | `git switch -c feature/x` |
| Update from remote | `git fetch` then `git rebase origin/main` (or `git pull`) |
| Publish | `git push` (`-u` the first time) |
| Undo unstaged edits to a file | `git restore file` |
| Unstage | `git restore --staged file` |
| Park work | `git stash push -u -m "msg"`, later `git stash pop` |

## History

| Do | Command |
|---|---|
| My branch's commits | `git log --oneline main..HEAD` |
| What would I pull? | `git fetch && git log HEAD..@{u}` |
| Who changed this line? | `git blame -w -C file` |
| When did this text appear/disappear? | `git log -S "text" -p` |
| History of one function | `git log -L :functionName:file.js` |
| Find the commit that broke it | `git bisect start BAD GOOD && git bisect run ./test.sh` |
| Is this fix in release X? | `git tag --contains <sha>`, `git branch -a --contains <sha>` |

## Rewriting (local / your own branch only)

| Do | Command |
|---|---|
| Fix last commit | `git commit --amend` |
| Clean up branch | `git rebase -i main` |
| Mark a fix for a past commit | `git commit --fixup <sha>` then `git rebase -i --autosquash main` |
| Move branch to a new base | `git rebase --onto main old-base feature` |
| Copy a commit | `git cherry-pick -x <sha>` |
| Push rewritten branch | `git push --force-with-lease` |

## Shared branches

| Do | Command |
|---|---|
| Undo a pushed commit | `git revert <sha>` |
| Undo a merged PR | `git revert -m 1 <merge-sha>` |
| Release tag | `git tag -a v1.2.0 -m "v1.2.0" && git push origin v1.2.0` |

## Rescue

`git reflog` · `git branch rescue <sha>` · `git reset --hard ORIG_HEAD` · `git fsck --unreachable` ·
`git merge --abort` · `git rebase --abort` — details in [recovery-playbook.md](recovery-playbook.md).
