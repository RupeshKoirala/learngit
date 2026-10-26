The release is the range `v2.0..v2.1`: commits reachable from v2.1 but not from v2.0. Start with
`git shortlog -sne v2.0..v2.1` (`-s` summary counts, `-n` sorted by count, `-e` show emails). Note the two Devs.
---
A `.mailmap` line has the form `Proper Name <proper@email> Commit Name <commit@email>`. If the old email is
enough to identify the person, you can drop the old name:
```
Dev Patel <dev@brightcart.example> <dev.patel@home.example>
```
Check it with `git check-mailmap "Dev P. <dev.patel@home.example>"`, then commit the file. `shortlog`
uses it automatically.
---
Counting: `git rev-list --count v2.0..v2.1`. Dates: `git rev-list --count --since=2025-03-01 v2.0..v2.1`
(`git log --since=... --oneline v2.0..v2.1 | wc -l` works too).
Hot files: `--name-only --format=` prints just the changed paths of every commit:
```bash
git log --format= --name-only v2.0..v2.1 | sort | uniq -c | sort -rn | head
```
---
```bash
echo 'Dev Patel <dev@brightcart.example> <dev.patel@home.example>' > .mailmap
git add .mailmap && git commit -m "Add .mailmap: merge Dev's two identities"
git shortlog -sne v2.0..v2.1           # top is now Dev Patel
```
Then write `top=...`, `commits=...`, `since=...`, `hotfile=...` into `../ANSWER`.
