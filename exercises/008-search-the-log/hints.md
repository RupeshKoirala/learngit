`git log` filters combine. Start with `git log --oneline --format='%h %ad %an  %s' --date=short` to see
who did what when. Then narrow down: `--author=Lena`, `--since=2025-03-01 --until=2025-03-07`,
`--grep=...`, `-- src/tax.js`.
---
- First commit of someone: `git log --author=Lena --reverse --oneline` — oldest first.
- `--grep` searches the **whole message** (subject *and* body), not just the line `--oneline` shows.
  `git log --grep='#42'` — a plain `42` would also match "1.42".
---
- Who created a file: `git log --diff-filter=A --oneline -- src/tax.js` (A = added). Without the filter,
  the *last* entry of `git log --oneline -- src/tax.js` is the creation.
- Searching **code**, not messages: the pickaxe `git log -S FREESHIP50 --oneline` lists commits where the
  number of occurrences of that string changed — the one that added it *and* the one that removed it.
  Add `-p` to see which is which.
---
Tag a commit: `git tag lena-first <hash>`. Check your work with `git log --oneline --decorate` or
`git show --stat <tag>`. Wrong commit? `git tag -f <name> <other-hash>` moves the tag.
