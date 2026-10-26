# "Oh no" → fix: the recovery playbook

Find your situation, run the fix. Exercise numbers point to where you practice it.
**Before any scary fix:** `git branch backup-$(date +%s)` — a free undo button.

## Commits

| Situation | Fix | Ex. |
|---|---|---|
| Typo in the last commit message (not pushed) | `git commit --amend -m "Better message"` | 004 |
| Forgot a file in the last commit (not pushed) | `git add file && git commit --amend --no-edit` | 004 |
| Amended the wrong thing | `git reset --soft HEAD@{1}` (reflog: HEAD before the amend) | 045 |
| Last 3 commits should be one (not pushed) | `git reset --soft HEAD~3 && git commit` | 037 |
| Messy commits before a PR | `git rebase -i main` (squash/fixup/reword/drop) | 022–025 |
| Committed to `main` instead of a branch | `git branch feature && git reset --hard origin/main && git switch feature` | 016 |
| Committed to the wrong branch | `git cherry-pick` them onto the right one, then `reset` the wrong one | 017 |
| A pushed commit is bad | `git revert <sha> && git push` — never reset shared branches | 038, 076 |
| A merged feature must come out | `git revert -m 1 <merge-sha>` | 039 |
| …and later goes back in | revert the revert (`git revert <revert-sha>`) | 040 |
| Wrong author/email on commits | `git rebase -r <base> --exec 'git commit --amend --no-edit --reset-author'` | 074 |

## Lost things

| Situation | Fix | Ex. |
|---|---|---|
| Deleted a branch | `git reflog` → `git branch name <sha>` | 041 |
| `reset --hard` too far | `git reflog` → `git reset --hard HEAD@{1}` | 042 |
| Rebase went wrong | `git reset --hard ORIG_HEAD` (right after) or find the old tip in `git reflog` | 029 |
| Dropped a stash | `git fsck --unreachable \| grep commit` → `git stash apply <sha>` | 043 |
| Need a file that was deleted long ago | `git log --diff-filter=D -- path` → `git restore --source=<sha>^ path` | 044 |
| Teammate force-pushed over your work | your local branch/reflog still has it → push it back carefully | 064 |
| Commits made in detached HEAD | `git reflog` → `git branch rescue <sha>` | 018 |

## Merges, rebases, conflicts

| Situation | Fix |
|---|---|
| Conflict and you want out | `git merge --abort` / `git rebase --abort` / `git cherry-pick --abort` |
| Want to see both sides + the original | `git config merge.conflictStyle zdiff3` (or `diff3`) |
| Take one whole side for a file | `git checkout --ours file` or `--theirs file`, then `git add file` |
| Same conflict every rebase | `git config rerere.enabled true` (ex. 083) |
| Push rejected (non-fast-forward) | `git pull --rebase` then push (ex. 061) |
| Need to force-push your own PR branch | `git push --force-with-lease` — never plain `--force` (ex. 063) |

## Dangerous stuff

| Situation | Fix | Ex. |
|---|---|---|
| Pushed a secret | **Rotate the secret first.** Then `git filter-repo --path .env --invert-paths`, force-push, tell everyone to re-clone, ask GitHub support to purge caches | 072 |
| Huge file in history | `git filter-repo --strip-blobs-bigger-than 10M`, consider Git LFS | 073 |
| Committed `node_modules`/build output | `git rm -r --cached node_modules dist`, add to `.gitignore`, amend/rebase | 080 |

## Commands that can destroy uncommitted work (pause before running)

`git reset --hard`, `git checkout -- <file>` / `git restore <file>`, `git clean -f`, `git stash drop`,
`git switch -f`. Committed work is almost always recoverable; uncommitted work usually isn't.
