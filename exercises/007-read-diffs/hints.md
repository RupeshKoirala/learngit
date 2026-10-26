`git diff` = working tree vs staging area (what you have **not** staged yet).
`git diff --staged` = staging area vs last commit (what the next commit **will** contain).
Add `--name-only` or `--stat` to each and compare the two file lists for **q1**.
---
For **q2**, a normal diff shows the whole long line as removed and re-added — hard to spot one word.
`git diff --word-diff README.md` shows `[-old-]{+new+}` inline (`--color-words` is the coloured version).
---
For **q3**, compare `git diff --stat main feature/gift-cards` with `git diff --stat main...feature/gift-cards`.
Two dots compare the two tips, so `main`'s own newer changes show up *reversed*. Three dots compare the branch
against the **merge base** — exactly what a GitHub pull request shows.
---
For **q4**, `git diff --stat v1.0 v1.1 -- src/cart.js` draws `+`/`-` bars; `--numstat` prints exact
numbers: `<added> <deleted> <path>`. Then fill in `../ANSWER`, e.g.:
```
q1=src/somefile.js
q2=someword
q3=7
q4=12
```
