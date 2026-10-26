`git subtree` takes a `--prefix` (the folder), a repository and a ref:

```bash
git remote add pricing-rules ../remotes/pricing-rules.git
git subtree add --prefix=vendor/pricing-rules pricing-rules v1.0.0 --squash
```
It needs a clean working tree.
---
Look at what it made: `./lg graph`. With `--squash` you get a squash commit (the whole of v1.0.0 as one
commit with no parents) and a merge commit that joins it into `main` under `vendor/pricing-rules/`.
`git log -1 --format=%B HEAD^2` (the merge's second parent = the squash commit) shows the
`git-subtree-dir` / `git-subtree-split` trailers Git uses later.
---
Updating is the same shape with `pull`:

```bash
git subtree pull --prefix=vendor/pricing-rules pricing-rules v1.1.0 --squash
```
Always pass `--squash` again: mixing squashed and unsquashed pulls on one prefix confuses subtree.
---
Verify against upstream: `git fetch pricing-rules` then `git diff pricing-rules/main HEAD:vendor/pricing-rules`
(upstream's `main` is v1.1.0). No output means the vendored folder is identical. `git log --oneline` should
show your two commits, then a squash + merge pair per release.
