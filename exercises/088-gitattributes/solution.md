# Solution

```bash
git ls-files --eol | grep -v 'i/lf'        # the damage: i/crlf, i/mixed
```

`.gitattributes`:

```
# Line endings: auto-detect text, store and check out LF everywhere
* text=auto eol=lf
*.bat text eol=crlf

# Binary assets: never convert, never diff
*.png binary

# Build output: collapsed in GitHub PRs, no textual diff
dist/** linguist-generated=true -diff

# Not part of release archives
tests/ export-ignore
.github/ export-ignore
.gitattributes export-ignore
```

```bash
git add --renormalize .                     # re-clean every tracked file through the new rules
git add .gitattributes
git ls-files --eol                          # i/lf everywhere, i/-text for the png
git commit -m "chore: normalize line endings with .gitattributes"

git rm -r -q --cached . && git reset -q --hard   # re-checkout so the working tree follows the rules too
sh scripts/deploy.sh                        # deploying storefront…
git check-attr -a dist/app.min.js scripts/install.bat
git archive HEAD | tar -t                   # no tests/, .github/, .gitattributes
```

**Why it works:**
- Git converts line endings in two places: when it *cleans* a file into the index (`git add`) and when it
  *smudges* a file out to your working tree (checkout). `text=auto` means "if Git's heuristic says it's text,
  store it with LF". `eol=lf` / `eol=crlf` decides what you get on checkout, regardless of anyone's
  `core.autocrlf`. Later lines win, so the `*.bat` rule overrides the `*` rule.
- Adding attributes changes nothing already stored. `git add --renormalize .` re-runs the clean step on every
  tracked file and stages those whose stored form changes — that's your normalization commit.
- The working tree isn't rewritten by that, because Git thinks those files are unchanged (their *cleaned*
  form matches the index). Removing everything from the index and `reset --hard` forces a fresh checkout.
- `binary` = `-text -diff -merge`. It matters: a PNG header literally contains the bytes `\r\n`. A rule like
  `* text eol=lf` (no `auto`) would "fix" them and corrupt every image.
- `-diff` makes `git diff` print `Binary files differ` for the minified bundle. `linguist-generated` is read by
  GitHub (not Git): those files are collapsed in PR diffs and ignored in language stats.
- `git archive` reads `export-ignore` from the attributes in the tree it archives — so the rule must be
  committed, and it only affects archives (and GitHub's "Download ZIP"/release tarballs), not clones.

**Real-world notes**
- Add `.gitattributes` on day one of a repo. Doing it later means one big "normalize" commit; put its hash in
  `.git-blame-ignore-revs` (and `git config blame.ignoreRevsFile .git-blame-ignore-revs`; GitHub honours the
  file automatically) so `git blame` skips it.
- Tell everyone to pull after the normalization commit; open branches will see endings-only conflicts. Merging
  with `-X renormalize` helps.
- `core.autocrlf` is a per-machine fallback (Windows: `true`, macOS/Linux: `input` or unset). Once
  `.gitattributes` sets `text`/`eol`, it wins. Prefer the attributes file: it's versioned and reviewable.
- Other useful attributes: `*.lock -diff` or `linguist-generated` for lock files, `*.svg text`, `*.sh text
  eol=lf`, `merge=ours` for files you never want to merge, `filter=lfs` (written for you by `git lfs track`),
  and `diff=<driver>` with `textconv` to diff `.docx`/images as text.
- Editors matter too: an `.editorconfig` with `end_of_line = lf` stops new CRLF files at the source.
