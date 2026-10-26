# Solution

```bash
git config rerere.enabled true            # this repo; use --global on your own machine

# 1) trial merge
git switch feature/multi-currency
git merge main                            # CONFLICT (content): Merge conflict in src/price.js
                                          # Recorded preimage for 'src/price.js'
# edit src/price.js to the agreed code, then
git rerere diff                           # what rerere will remember (preimage -> your fix)
git add src/price.js
git commit --no-edit                      # Recorded resolution for 'src/price.js'.

# 2) Maya: no merge commits in feature branches
git reset --hard HEAD~1                   # or ORIG_HEAD right after the merge

# 3) rebase; the same conflict replays itself
git rebase main
# CONFLICT (content): Merge conflict in src/price.js
# Resolved 'src/price.js' using previous resolution.
git diff                                  # sanity check: no markers, the agreed code
git add src/price.js
git rebase --continue

git log --oneline --graph main..feature/multi-currency
```

**Why it works:** with `rerere.enabled`, every time a conflict appears Git hashes its *shape* (the two
conflicting sides, normalized so it doesn't matter which side is "ours") and stores the **preimage** in
`.git/rr-cache/<hash>/`. When you commit the resolved file, Git stores your **postimage** next to it. Next time
the exact same conflict shows up — in a merge, a rebase, a cherry-pick, a revert — Git recognizes the hash and
applies your postimage. It leaves the path "unmerged" on purpose so you review before `git add`; set
`rerere.autoUpdate true` to stage it automatically.

The rebase hits the same conflict because the commit `feat(price): accept a currency code` replays your exact
change to `formatPrice` onto Maya's version: same two sides, same hash, same fix.

**Real-world notes**
- Turn it on globally once and forget it: `git config --global rerere.enabled true`. It costs nothing.
- Classic uses: long-lived feature branches you rebase often; **trial merges** to check that a branch still
  integrates (`git merge main && ... && git reset --hard HEAD~1`) without leaving merge commits; maintainers
  re-doing an integration branch (`next`, `seen` in git.git) every day; re-running a rebase after `--abort`.
- A wrong recorded resolution is replayed just as faithfully. Fix it with `git rerere forget src/price.js`
  while the conflict is present, then resolve again. `git rerere gc` prunes old entries
  (`gc.rerereResolved`, default 60 days).
- `rr-cache` is local to your clone. To share resolutions you'd have to copy the folder (some teams do, with
  `rerere-train.sh` from git's `contrib/` to learn resolutions from existing merge commits).
- rerere makes rebase-heavy workflows cheap, but the best fix for recurring conflicts is still integrating
  more often: small PRs and frequent rebases keep conflicts tiny.
