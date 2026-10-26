Diagnose first: `git ls-files --eol` prints, per file, the endings in the index (`i/`), in your working tree
(`w/`) and the attributes that apply (`attr/`). Look for `i/crlf` and `i/mixed`. `git check-attr -a <path>`
shows every attribute for one path.
---
`.gitattributes` lines are `pattern attr attr…`, later lines win. A good start:

```
* text=auto eol=lf
*.bat text eol=crlf
*.png binary
```
`binary` is a macro for `-text -diff -merge`. (What would `* text eol=lf` without `auto` do to the `\r\n`
bytes inside every PNG header?)
---
Generated and export rules:

```
dist/** linguist-generated=true -diff
tests/ export-ignore
.github/ export-ignore
.gitattributes export-ignore
```
Then `git add --renormalize .` re-runs the conversion on every tracked file and stages the fixes.
`git add .gitattributes`, check `git ls-files --eol` again, and commit, e.g.
`chore: normalize line endings with .gitattributes`.
---
The index is fixed, but your working tree still has CRLF files (Git considers them unchanged). Re-checkout
everything from the index:

```bash
git rm -r -q --cached . && git reset -q --hard
sh scripts/deploy.sh
```
`git ls-files --eol` should now show `w/lf` everywhere except `w/crlf` for the `.bat` file.
