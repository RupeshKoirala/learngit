# Solution

```bash
mkdir .githooks
```

`.githooks/pre-commit`:

```sh
#!/bin/sh
# Shared pre-commit hook: block secrets and stray console.log in the lines this commit ADDS.
added=$(git diff --cached --no-color -U0 --diff-filter=ACMR | grep '^+' | grep -v '^+++')
status=0
if printf '%s\n' "$added" | grep -q 'console\.log('; then
  echo "pre-commit: remove debug console.log calls (use the logger instead)." >&2
  status=1
fi
if printf '%s\n' "$added" | grep -qE -e 'sk_live_[A-Za-z0-9]+' -e '-----BEGIN [A-Z ]*PRIVATE KEY-----'; then
  echo "pre-commit: this looks like a secret. Load it from the environment instead." >&2
  status=1
fi
exit $status
```

`.githooks/commit-msg`:

```sh
#!/bin/sh
subject=$(head -n 1 "$1")
case "$subject" in "Merge "*) exit 0 ;; esac
if printf '%s\n' "$subject" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9._/-]+\))?!?: .+'; then
  exit 0
fi
echo "commit-msg: '$subject' is not a Conventional Commit (e.g. feat(cart): add bulk discount)" >&2
exit 1
```

```bash
chmod +x .githooks/pre-commit .githooks/commit-msg
git config core.hooksPath .githooks
git add .githooks
git commit -m "chore: add shared git hooks"      # your own commit-msg hook checks this one
git ls-files -s .githooks                         # 100755 = executable bit recorded

# try it yourself
echo "console.log('x')" >> src/cart.js && git commit -am "feat: test"   # rejected
git restore src/cart.js
```

**Why it works:** Git looks for hooks in `$GIT_DIR/hooks` unless `core.hooksPath` says otherwise. A relative
`core.hooksPath` is resolved from the top of the working tree, so `.githooks` works in every clone and every
worktree. `pre-commit` runs before the message is even asked for; anything non-zero aborts. `git diff --cached
-U0` shows exactly the staged change with no context lines, so you judge only what is being *added* — that's
why touching or deleting old `console.log` lines in `scripts/seed.js` is still fine. `commit-msg` receives the
path of the message file as `$1`; Git also runs it for merge commits, which is why `Merge …` must pass.

**Gotcha you may have hit:** a hook whose own source or error message contains `console.log(` blocks the
commit that adds the hook! That's why the pattern is written `console\.log(` and the message avoids the paren.

**Real-world notes**
- `core.hooksPath` is per-clone config, so it isn't shared automatically. Teams set it in an onboarding step:
  `make setup`, an npm `prepare` script, or tools like **husky**, **lefthook** and **pre-commit** (Python)
  that install and version hooks for you.
- Hooks run on the developer's machine and can be skipped with `git commit --no-verify` (or `-n`). They are a
  fast feedback loop, **not** a security control. Enforce the same rules server-side: secret scanning and
  push protection on GitHub, plus a CI job (e.g. `commitlint`, `gitleaks`) that runs on every PR.
- Keep hooks fast (under a second) and only check staged content; slow hooks train people to use
  `--no-verify`. Print *how to fix*, not just "rejected".
- Once a secret is pushed, deleting it in a new commit isn't enough: **rotate the key first**, then decide
  whether to rewrite history (that is what `git filter-repo` is for).
- Consider letting `fixup!`/`squash!` subjects through `commit-msg`, otherwise `git commit --fixup` breaks.
