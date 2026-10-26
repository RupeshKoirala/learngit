Git stores only two modes for regular files: `100644` and `100755`. List them with `git ls-files -s`, and
`git ls-files -s | grep ^100755` shows the offenders.
---
With `core.fileMode=true`, Git notices permission changes on disk. So fixing the disk and running `git add` works:
`chmod 644 README.md .gitignore src/*.js docs/*.md` then `chmod 755 test.sh`, then `git status` / `git diff`.
---
You can also flip the bit directly in the index, without touching the disk:
`git update-index --chmod=+x test.sh` (or `--chmod=-x <files>`). Then also `chmod` the disk files, or `git status` will
show them as changed.
---
```bash
git ls-files -s | awk '$1 == "100755" {print $4}' | xargs chmod 644
chmod 755 test.sh
git add -A && git diff --cached --summary      # only "mode change" lines
git commit -m "Restore file modes; make test.sh executable"
```
