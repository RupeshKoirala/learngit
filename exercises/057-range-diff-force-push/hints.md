`git fetch` prints `+ 896009b...0cb0df1 feature/wishlist -> origin/feature/wishlist (forced update)`. Those two
hashes are v1 and v2. Even if you lose that output, `git reflog origin/feature/wishlist` still has them:
`origin/feature/wishlist@{1}` is v1, `origin/feature/wishlist` is v2.
---
`git range-diff` has three forms:
```
git range-diff <base> <old-tip> <new-tip>
git range-diff <old-base>..<old-tip> <new-base>..<new-tip>
git range-diff <old-tip>...<new-tip>
```
The first one fits here: `<base>` is a commit both versions build on, so `origin/main` (new main contains old
main) works.
---
```bash
git range-diff origin/main origin/feature/wishlist@{1} origin/feature/wishlist
```
Each line pairs an old commit with a new one: `=` identical, `!` changed (the diff below shows how),
`<` only in v1 (dropped), `>` only in v2 (added). Look *inside* each `!` block. Is the change under
`## Commit message ##` or under a file?
---
The `!` for `Cap wishlist size` changes a code line (`MAX_ITEMS`). The `!` for the API endpoint only changes
the message. The `<` line shows the dropped commit's v1 hash.
```bash
git tag changed-commit <v2 hash from the right-hand column>
printf 'cap=%s\ndropped=%s\n' <value> <v1 hash> > ../ANSWER
```
