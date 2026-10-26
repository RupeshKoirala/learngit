# Solution

```bash
git fetch
#  + 896009b...0cb0df1 feature/wishlist -> origin/feature/wishlist  (forced update)
git reflog origin/feature/wishlist          # @{0} = v2, @{1} = v1

git range-diff origin/main origin/feature/wishlist@{1} origin/feature/wishlist
# 1:  f001b33 = 1:  99dbf9d Add wishlist model                  <- identical patch, only rebased
# 2:  46ee316 ! 2:  2f14655 Add wishlist API endpoint
#     @@ Metadata
#       ## Commit message ##
#     -    Add wishlist API endpoint
#     +    Add GET/POST /api/wishlist endpoint                     <- message only
#     +
#     +    POST adds an item, GET returns the list.
# 3:  da9060a ! 3:  0cb0df1 Cap wishlist size
#       ## src/wishlist.js ##
#     -+const MAX_ITEMS = 50;
#     ++const MAX_ITEMS = 20;                                       <- code changed
# 4:  896009b < -:  ------- Add debug logging for wishlist        <- dropped

git tag changed-commit 0cb0df1
printf 'cap=20\ndropped=896009b\n' > ../ANSWER
```

**How to read it:** each line pairs a v1 commit (left) with its v2 version (right).
`=` the patch is identical (the hash changed only because of the rebase), `!` something changed, `<` only in
v1 (dropped), `>` only in v2 (new). Below each `!` is a **diff of diffs**: the first `-`/`+` column says
whether the line was removed or added *between versions*, the second is the original patch's own `-`/`+`. So
`-+const MAX_ITEMS = 50;` means "v1 added this line, v2 no longer does".

**Why it works:** `range-diff` matches commits between the two ranges by how similar their patches are,
not by hash or message, so it survives rebases, rewording and reordering. The three forms are the same
thing with different shorthands:
- `git range-diff <base> <old> <new>`: both ranges start at `<base>` (here `origin/main`, which contains
  the old base),
- `git range-diff A..B C..D`: explicit ranges, e.g. `old-main..v1 new-main..v2`,
- `git range-diff v1...v2`: uses the merge base. Here that's the *old* main, so the two new `main` commits
  would show up as `>` noise.

A plain `git diff v1 v2` would mix Lena's real change with everything that landed on `main` overnight.

**Real-world notes**
- **GitHub's "Compare" link** on a force-push event shows a tip-to-tip diff, so it has the same noise problem.
  `range-diff` is how careful reviewers re-review a rebased PR, and how maintainers of projects that review
  by email (Git itself, the Linux kernel) compare patch series v1/v2/v3.
- **Lost the old hash?** The reflog of your remote-tracking ref remembers it (`origin/<branch>@{1}`), as does
  the fetch output and the PR's timeline ("force-pushed from 896009b to 0cb0df1").
- **As the author**, make re-review easy: rebase *without* changing unrelated commits, and say in the PR
  comment what changed: "v2: cap 50→20 per review, reworded endpoint commit, dropped debug logging".
  Paste the `range-diff` if your team likes that.
- **As a lead**, a "dropped" commit is worth a glance: was it supposed to go (debug logging), or did a
  rebase conflict lose real work?
- Use `--creation-factor=<n>` if range-diff fails to pair a heavily edited commit and shows it as `<` + `>`
  instead of `!`.
