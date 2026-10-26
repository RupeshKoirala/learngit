# Solution

```bash
git status                              # notes.txt staged, src/price.js modified
git reset -- notes.txt                  # 1. unstage (a --mixed reset limited to one path)
#   same thing, modern spelling:  git restore --staged notes.txt

git log --oneline main..HEAD            # the 3 commits to combine
git reset --soft HEAD~3                 # 2. branch back to main, changes stay STAGED
git status                              #    src/shipping.js staged, notes.txt untracked
git commit -m "Add free shipping threshold"

git restore src/price.js                # 3. throw away the experiment
#   old spelling:  git checkout -- src/price.js

echo hard > ../ANSWER                   # 4.
git status --short                      # ?? notes.txt
```

**Why it works:** Git has three places your code lives — the **commit** your branch points at, the
**index** (what the next commit will contain) and the **working tree** (your files). `reset` always moves the
branch; the mode decides how many of the other two are overwritten to match:

| mode | branch | index | working tree | typical use |
|---|---|---|---|---|
| `--soft` | moved | kept | kept | squash the last N commits, re-do a commit |
| `--mixed` (default) | moved | reset | kept | unstage; "uncommit but keep my edits unstaged" |
| `--hard` | moved | reset | **reset** | throw away everything since a commit |

`reset --soft HEAD~3` leaves the index holding the tree of your last commit, so the next `commit` captures
all three commits' work at once. With a path (`git reset -- notes.txt`) reset can't move the branch, so it
only copies the path from `HEAD` into the index — that's "unstage".

**Why `hard` is the answer:** `notes.txt` was staged but not in any commit. `git reset --hard` makes the
index and working tree match the target commit, so files that only existed in the index are **deleted from
disk**. Uncommitted changes don't live in the reflog, so there's no `git reflog` rescue. (Because the file was
*staged*, its blob is still in `.git/objects` and `git fsck --lost-found` could dig it out — exercise 043 shows
the technique — but unstaged edits like the price.js experiment would be gone forever.)

**Real-world notes**
- Before any `--hard`, run `git status` and ask "is there anything here I haven't committed or stashed?".
  When unsure, `git stash -u` first — a stash is recoverable, a hard reset of uncommitted work isn't.
- Prefer the targeted tools: `git restore <file>` for one file, `git restore --staged <file>` to unstage,
  `git reset --soft`/`git commit --amend` to rework commits. Reach for `reset --hard` only when you *mean*
  "make everything look like that commit".
- `reset --soft HEAD~N` squashing is the quickest way to tidy a local branch; it does the same job as
  `rebase -i` with `fixup` (exercise 022) when you want everything in one commit.
- All of this rewrites history: fine for unpushed work. If the commits were already pushed to a shared
  branch, use `git revert` instead (exercise 038).
- `git reset --keep <commit>` is a safer `--hard`: it refuses if it would overwrite your local changes.
