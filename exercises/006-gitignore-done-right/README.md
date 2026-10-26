# .gitignore done right: untrack, negate, debug

Security review flagged the repo: **`.env` with a live API key is committed**, so are `node_modules/` and a
log file. The root `.gitignore` only contains `*.tmp`. Maya asks you to fix it properly.

```
$ git ls-files
.env                <- secret!           .gitignore   (only "*.tmp")
.env.example        <- keep tracked      README.md
.env.local          <- personal          assets/.gitignore
logs/.gitkeep       <- keep tracked      assets/banner.svg
logs/app.log        <- noise             package.json, src/…, test.sh
node_modules/…      <- dependencies
```

Separately, Sam (PM) sent you the official logo, `assets/logo.png`. When you try to `git add` it, Git says
it's ignored — and nobody knows why.

## Your task

1. Make the **root** `.gitignore` ignore: `node_modules/`; `.env` and every `.env.*` file **except**
   `.env.example`; everything inside `logs/` **except** `logs/.gitkeep`; and `*.log` files anywhere.
2. **Stop tracking** `node_modules/`, `.env`, `.env.local` and `logs/app.log` — but keep them on disk
   (your app still needs them).
3. Find out **which file** is ignoring `assets/logo.png`. Write that file's path (e.g. `some/dir/.gitignore`)
   into `ANSWER` in the sandbox folder: `echo "…" > ../ANSWER`.
4. Commit `assets/logo.png` — without un-ignoring the other `*.png` exports.
5. Commit everything; finish with a clean working tree.

## You'll practice

`.gitignore` pattern syntax (`dir/`, `*`, `!negation`, `dir/*` vs `dir/`), `git rm --cached`,
`git check-ignore -v`, `git ls-files`, nested `.gitignore` files and `git add -f`.
