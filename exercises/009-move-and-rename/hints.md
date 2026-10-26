`git mv old new` moves the file on disk and stages the move in one step. Create target folders first
(`mkdir -p src/cart src/utils scripts`). `git status` should then say `renamed:` for each file.
---
Git doesn't record renames — it **detects** them by comparing content. A file that moved *and* changed a
lot looks like "deleted + added". That's why the move gets its own commit with zero edits:
`git show --stat HEAD` should show `{ => cart}/cart.js` style renames and `0` changed lines.
---
```bash
mkdir -p src/cart src/utils scripts
git mv src/cart.js src/cart/cart.js
git mv src/price.js src/utils/format-price.js
git mv test.sh scripts/test.sh
git commit -m "Reorganize source folders"
# edit README.md, then:
git commit -am "Update test command in README"
```
---
`git log -- src/utils/format-price.js` stops at the move. `git log --follow --oneline -- src/utils/format-price.js`
follows the file across renames — the oldest (last) entry is the commit that created it:
`git log --follow --format=%H -- src/utils/format-price.js | tail -1 > ../ANSWER`
