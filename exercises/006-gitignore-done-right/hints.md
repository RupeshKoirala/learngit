`.gitignore` only affects files Git is **not yet tracking**. Adding `.env` to it does nothing while `.env`
is committed. `git rm --cached <path>` removes a file from the index (the next commit) but leaves it on
disk; for folders add `-r`: `git rm -r --cached node_modules`.
---
Pattern rules: a later `!pattern` re-includes something an earlier pattern excluded — **unless a parent
directory is excluded**. `logs/` excludes the whole folder, so `!logs/.gitkeep` can never win. Exclude the
*contents* instead: `logs/*` then `!logs/.gitkeep`. Same idea for env files: `.env`, `.env.*`, `!.env.example`.
---
`git check-ignore -v assets/logo.png` prints `<source file>:<line>:<pattern>  <path>` — the exact rule
that matches. Ignore files can live in any folder and also in `.git/info/exclude` and your global excludes
file. Put the source file path into `../ANSWER`.
---
To commit the logo without un-ignoring all PNGs, either add `!logo.png` to `assets/.gitignore`, or force
it once with `git add -f assets/logo.png` (once tracked, ignore rules no longer apply to it). Then:

```bash
git rm -r --cached node_modules .env .env.local logs/app.log
git add .gitignore assets/
git status                 # deletions staged, files still on disk
git commit -m "Stop tracking dependencies, secrets and logs"
```
