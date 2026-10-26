You don't need a new commit — you need to *replace* the last one. `git commit --amend` takes whatever is
staged right now, combines it with the previous commit's content, and lets you rewrite the message.
---
Stage the forgotten file first, then amend:

```bash
git add src/banner.css
git commit --amend
```
Your editor opens with the old message — fix the typo, save, close.
---
Prefer the command line? `git commit --amend -m "Add free shipping banner"` sets the message directly.
(Only fixing the file, not the message? `git commit --amend --no-edit`.)
---
Check with `git log --oneline` (still 3 commits) and `git show --stat HEAD` (two files). Notice the hash
changed: amend creates a brand-new commit. The old one is still listed in `git reflog` if you ever need it.
