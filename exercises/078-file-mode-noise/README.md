# File-mode noise: undo a chmod 755 on everything

Lena's editor plugin ran `chmod -R 755` before she committed `Format cart code`. Her pull request showed a single
real change… and six `old mode 100644 / new mode 100755` entries nobody noticed. Now every file is executable
in Git. Meanwhile the one file that *should* be executable, `test.sh`, never was in Git, so CI has to run it as
`sh test.sh`.

```
* Format cart code             <- main   (1 real change + mode 100644 -> 100755 on 6 files)
* Add setup and style docs
* Initial storefront                     (test.sh committed as 100644)
```

See it: `git show --stat --summary HEAD` and `git ls-files -s`.

## Your task

On `main`, with **new commit(s)** (main is shared — don't rewrite Lena's commit):

1. Every tracked file is mode `100644` in Git, **except** `test.sh`, which is `100755`.
2. File contents don't change (Lena's real edit to `src/cart.js` stays).
3. Keep `core.fileMode=true` in this repo — turning it off would only *hide* the noise on your machine.
4. Leave a clean working tree (your disk permissions match what's in Git), so `./test.sh` runs directly.

## You'll practice

`git ls-files -s`, `git diff --summary`, `chmod`, `git update-index --chmod=+x|-x`, and what `core.fileMode` does.
