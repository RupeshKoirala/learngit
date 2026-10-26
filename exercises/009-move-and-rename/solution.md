# Solution

```bash
mkdir -p src/cart src/utils scripts
git mv src/cart.js  src/cart/cart.js
git mv src/price.js src/utils/format-price.js
git mv test.sh      scripts/test.sh
git status                                 # renamed: ... (x3)
git commit -m "Reorganize source folders"
git show --stat HEAD                       # 3 files changed, 0 insertions(+), 0 deletions(-)

# edit README.md: ./test.sh -> ./scripts/test.sh
git commit -am "Update test command in README"

git log --oneline -- src/utils/format-price.js           # only the move commit
git log --oneline --follow -- src/utils/format-price.js  # the full story, back to "Add price formatting"
git log --follow --format=%h -- src/utils/format-price.js | tail -1 > ../ANSWER
git blame src/utils/format-price.js                      # lines still credited to Dev, Lena, Maya
```

**Why it works:** Git stores snapshots, not "rename" events. `git mv a b` is just `mv a b && git rm a &&
git add b`. When you look at history, Git compares the two snapshots and pairs a deleted file with an added
file if their content is similar enough (≥50% by default, tune with `-M70%`). An unchanged move scores
100%, so `log --follow`, `blame`, `diff` and merges all keep tracking the file. Moving *and* rewriting it
in the same commit can push similarity below the threshold — then the history appears to start fresh.

**Real-world notes**
- **Move first, edit later — in separate commits** (ideally a separate PR). Reviewers can skim a pure-rename
  commit in seconds, and rename detection stays reliable. Ask reviewers to use GitHub's "files moved" view.
- Big moves cause painful conflicts for everyone with open branches. As a lead, announce the move, merge it
  quickly (e.g. at a sprint boundary), and tell people to rebase right after. Git's merge does follow renames
  (`merge.renames`), so most edits land in the moved file automatically.
- Add mass-reformat or move commits to `.git-blame-ignore-revs` and set
  `git config blame.ignoreRevsFile .git-blame-ignore-revs` (GitHub honours the file too) so `blame` skips them.
- On case-insensitive filesystems (macOS, Windows) renaming `Cart.js` → `cart.js` needs `git mv`; a plain
  `mv` may not be noticed at all.
