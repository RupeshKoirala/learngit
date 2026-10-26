# Solution

```bash
git add src/banner.css
git commit --amend -m "Add free shipping banner"
git log --oneline            # still 3 commits, new hash on top
git show --stat HEAD         # banner.js + banner.css
```

**Why it works:** commits are immutable. `--amend` doesn't edit the old commit; it builds a **new** commit
from the current staging area (which still contains everything from the last commit plus `banner.css`),
gives it the same parent as the old one, and moves `main` to it. The old commit (`Add free shiping banner`)
is now unreferenced — you can still see it in `git reflog` for a while (90 days by default), and get it
back with `git reset --hard HEAD@{1}`.

```
before:  Initial ── removeItem ── "free shiping" (banner.js)          <- main
after:   Initial ── removeItem ── "free shipping" (banner.js + .css)  <- main
                              └── "free shiping"  (orphaned, in reflog only)
```

**Real-world notes**
- **Amend only unpushed commits.** If the commit is already on the remote, amending rewrites published
  history: you'd have to force-push, and anyone who pulled it gets a diverged branch. On your own feature
  branch before review that's acceptable (`git push --force-with-lease`); on `main`, never — add a new
  commit instead.
- `git commit --amend --no-edit` is the everyday version: "I forgot a file / a lint fix" without touching
  the message. `--amend --reset-author` also refreshes the author date.
- To fix an *older* commit (not the last one), use `git commit --fixup <hash>` and
  `git rebase -i --autosquash` (Rebase module).
- Typos in commit titles matter more than they seem: titles end up in changelogs, release notes and
  `git log --oneline` that the whole team reads for years.
