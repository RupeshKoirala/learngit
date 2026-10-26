# Solution

```bash
cd repo
git count-objects -vH                   # size-pack: ~20 MiB for a repo of text files
git rev-list --objects --all \
  | git cat-file --batch-check='%(objectsize) %(objecttype) %(rest)' \
  | sort -n | tail -3                   # 20971520 blob assets/promo-video.mov

git filter-repo --path assets/promo-video.mov --invert-paths --force
#   or, when you don't know every culprit:  git filter-repo --strip-blobs-bigger-than 5M --force

git count-objects -vH                   # size-pack: a few KiB
git log --all --oneline -- assets/promo-video.mov   # nothing

git remote add origin ../remotes/origin.git
printf '*.mov\n*.mp4\n' >> .gitignore
git add .gitignore && git commit -m "Ignore video files (use the CDN or Git LFS)"
git push --force origin --all
git branch -u origin/main
```

**Why it works:** "deleting" a file in a new commit only changes the *latest* tree; the old commits still point
at the 20 MB blob, and a clone fetches every object reachable from every branch. filter-repo rebuilds each commit
without that path, so the blob becomes unreachable. It then expires the reflog and runs `git gc --prune=now`,
which is what actually frees the space locally (`count-objects` proves it). `Remove promo video` became an
empty commit and filter-repo drops it by default, so main has one commit fewer — expected.

**Real-world notes**
- **The server keeps the old objects** until it garbage-collects them. On GitHub, unreachable objects (and old
  pull-request refs that still point at them) can linger; contact GitHub Support if the size must drop now.
  `git count-objects` on the bare remote here still shows 20 MB — run
  `git --git-dir=../remotes/origin.git gc --prune=now` to see what a server-side gc does.
- **Everyone must re-clone.** Old clones still contain the blob and will happily push it back with the old commits.
  Announce a freeze, rewrite, push, then have everyone re-clone. Open PRs need rebasing onto the new history.
- **Use Git LFS for large binaries.** `git lfs track "*.mov"` stores a tiny pointer file in Git and the content on
  an LFS server; clones only download the versions they check out. For an existing repo,
  `git lfs migrate import --include="*.mov" --everything` rewrites history to pointers (same coordination rules).
- Prevent it: a CI check or pre-receive hook rejecting files over N MB, and GitHub's own push limit (100 MB hard,
  a warning at 50 MB). A `.gitignore` entry stops accidents, not determined pushes.
- Short-term relief for consumers without rewriting: `git clone --filter=blob:none` (partial clone) or
  `--depth 1` for CI.
