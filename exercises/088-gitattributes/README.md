# .gitattributes: fix the CRLF mess, tame generated files

Jo just joined and works on Windows with `core.autocrlf=false`. Their first PR committed files with CRLF
(`\r\n`) line endings. Now:
- `src/price.js` shows **every line changed** in the diff, although Jo changed nothing in it.
- `scripts/deploy.sh` **fails on Linux/macOS** with an error like `set: Illegal option -` (the shell sees `set -e\r`).
- `docs/setup.md` has *mixed* endings.

Meanwhile every PR that touches the bundle shows a 1-line, 4 KB diff of `dist/app.min.js` that nobody can
review, and the release ZIP ships `tests/` and `.github/`.

Per-developer settings like `core.autocrlf` can't fix this for everyone. A committed **`.gitattributes`**
can: it travels with the repo and applies to every clone and every OS.

```
* build: rebuild dist/app.min.js                                  <- main
* feat(checkout): add checkout + Windows install script   (Jo, CRLF files)
* build: bundle dist/app.min.js
* chore: initial storefront
```

## Your task

In `repo`, add a `.gitattributes` and commit it **together with the normalization**, in one new commit on
`main`, so that:

1. **Line endings:** Git auto-detects text files (`text=auto`) and every text file is stored in the
   repository with **LF** and checked out with **LF**, on every OS.
   Exception: `*.bat` files are text checked out with **CRLF** (Windows `cmd` wants them).
2. **Binary:** `*.png` files are binary (no line-ending conversion, no text diff). `assets/logo.png` must stay
   byte-for-byte identical.
3. **Generated:** everything under `dist/` is marked `linguist-generated` (GitHub collapses it in PRs) and has
   **no textual diff** (`-diff`).
4. **Release archives:** `tests/`, `.github/` and `.gitattributes` itself are left out of `git archive`
   (`export-ignore`).
5. **Renormalize** the files already in the repo so none is stored with CRLF or mixed endings, and refresh your
   working tree so `sh scripts/deploy.sh` runs again (and `scripts/install.bat` is CRLF on disk).

Don't change file contents other than line endings, don't rewrite existing commits, and leave the tree clean.

## You'll practice

`.gitattributes` patterns, `text=auto`, `eol=lf|crlf`, the `binary` macro, `-diff`, `linguist-generated`,
`export-ignore`, `git add --renormalize`, `git ls-files --eol` and `git check-attr`.
