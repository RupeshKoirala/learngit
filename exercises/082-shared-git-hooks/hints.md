A hook is just an executable file with a special name. Git runs `pre-commit` before it even asks for a
message, and `commit-msg` with **one argument: the path of a file holding the message**. A non-zero exit
code aborts the commit. Start with `mkdir .githooks` and `git config core.hooksPath .githooks`.
---
For pre-commit, the staged diff is `git diff --cached`. Added lines start with `+` (but the `+++ b/file`
header lines do too, so filter them out):

```sh
added=$(git diff --cached -U0 | grep '^+' | grep -v '^+++')
```
Then `printf '%s\n' "$added" | grep -q 'console\.log('` tells you whether to block.
---
For commit-msg, read the first line with `head -n 1 "$1"` and match it with `grep -qE`:

```sh
'^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9._/-]+\))?!?: .+'
```
Let `^Merge ` through before you test the pattern. Start both files with `#!/bin/sh`.
---
Don't forget `chmod +x .githooks/*` — Git silently ignores a hook that isn't executable (it prints a
"hint: … ignored because it's not set as executable"). Git records the executable bit, so after `chmod` the
file is staged as mode `100755`; check with `git ls-files -s .githooks`. Then
`git add .githooks && git commit -m "chore: add shared git hooks"`.
