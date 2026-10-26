# Solution

```bash
git log --oneline --grep "code freeze"            # find the cut point
git switch -c release/2.0 <freeze-hash>           # or: git switch -c release/2.0 ':/code freeze'
./test.sh                                         # BC-201 and BC-202 fail

# BC-201: TAX_RATE = 0.08 in src/checkout.js
git commit -am "fix(checkout): tax rate is 8%, not 80% (BC-201)"
# BC-202: toFixed(2) in src/price.js
git commit -am "fix(price): show two decimals (BC-202)"
./test.sh                                         # tests passed

git tag -a v2.0.0 -m "Brightcart 2.0.0"
git switch main
git merge --no-ff release/2.0                     # fixes flow back into 2.1
git push --follow-tags origin main release/2.0    # or: git push origin main release/2.0 v2.0.0
git ls-remote origin                              # verify branches + tag on the server
```

**Why it works:** a branch is just a pointer, so `release/2.0` can start at the freeze commit even though
`main` is two commits ahead. The release branch then only ever receives *fixes*, which keeps 2.0 stable
while `main` keeps moving. Tagging the release-branch commit records exactly what shipped; merging the
branch back means 2.1 can't regress BC-201/BC-202. The merge is conflict-free because the release branch never
touched `VERSION` after the freeze.

**Real-world notes**
- **Annotated vs lightweight tags:** annotated tags store tagger, date and message and can be signed
  (`git tag -s`). `git describe` ignores lightweight tags by default, and `--follow-tags` only pushes annotated
  ones. Use annotated tags for every release; lightweight ones are for private bookmarks.
- **Two fix strategies.** *Fix on the release branch, merge back* (git-flow, what you did) is simple. Many big
  projects prefer **upstream first**: fix on `main`, then `git cherry-pick -x` onto the release branch, so `main`
  is always the source of truth and the release branch never needs merging back. Pick one and write it in your
  CONTRIBUTING.md — mixing them is how fixes get lost.
- **Keep release branches boring.** Protect `release/*` on GitHub (required reviews, no force pushes), only allow
  bug fixes, and delete or freeze the branch once the next minor ships.
- **Tags are forever.** Once `v2.0.0` is pushed, never move it. If you made a mistake, release `v2.0.1`.
  Downstream caches, package registries and teammates' clones will keep the old tag anyway.
- On GitHub, create a **Release** from the tag (`gh release create v2.0.0 --generate-notes`) so PMs and
  customers get human-readable notes (exercise 093).
