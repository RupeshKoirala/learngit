Find the culprit like you would in a repo you don't know:

```bash
git count-objects -vH
git rev-list --objects --all | git cat-file --batch-check='%(objectsize) %(objecttype) %(rest)' | sort -n | tail -3
```
---
`git filter-repo` rewrites every branch and tag. Two ways to say "drop the video":
`--path assets/promo-video.mov --invert-paths` (precise) or `--strip-blobs-bigger-than 5M` (catches everything big).
It needs `--force` here because the repo isn't a fresh clone.
---
filter-repo removes `origin` and repacks for you. Afterwards `git count-objects -vH` should show a few KiB.
Then: `git remote add origin ../remotes/origin.git`, add `*.mov` to `.gitignore` and commit it.
---
Push the rewritten branches over the old ones: `git push --force origin --all`
(then `git branch -u origin/main` so `main` tracks origin again).
