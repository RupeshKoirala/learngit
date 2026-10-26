Zoom in on one line at a time: `git blame -L '/FREE_SHIPPING/,+1' src/shipping.js`. When blame names a
"boring" commit (a reformat, a re-indent, a move), you don't stop there. You ask blame to look *past* it.
`git show <hash>` tells you what a commit did and why.
---
Three ways to look past a boring commit:
- `--ignore-rev <hash>`: pretend that commit never touched the line,
- `-w`: whitespace-only changes don't count,
- `git blame <hash>^ -- src/shipping.js`: start blaming from the commit *before* the boring one.
For code that was moved from another file, add `-C`, which makes blame look for the lines in other files changed
by the same commit.
---
Threshold: `git blame --ignore-rev <prettier-hash> -L '/FREE_SHIPPING/,+1' src/shipping.js` names Dev's
commit. `git show <that-hash>` shows the ticket. Tag it with `git tag threshold-change <hash>`.

Express rule: blaming past the bot lands on Jo's re-indent, then on Maya's *Extract* commit. Restart blame
**before** the bot and let it follow whitespace and the move:
`git blame -w -C <prettier-hash>^ -- src/shipping.js`. Blame the whole file or the whole function
(`-L :shippingFor`), not just one line: `-C` only recognises a moved chunk of at least ~40 letters and
digits, and one short line is too small.
---
The ignore file:
```bash
git rev-parse <prettier-hash> > .git-blame-ignore-revs     # full 40-char hash
git add .git-blame-ignore-revs
git commit -m "Ignore the prettier reformat in git blame"
git config blame.ignoreRevsFile .git-blame-ignore-revs
git blame -L '/FREE_SHIPPING/,+1' src/shipping.js           # now shows Dev
```
