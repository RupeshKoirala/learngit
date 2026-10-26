cd repo
mkdir -p .githooks
cat > .githooks/pre-commit <<'HOOK'
#!/bin/sh
# Shared pre-commit hook: block secrets and stray console.log in the lines this commit ADDS.
# Bypass in a real emergency with `git commit --no-verify` (and tell your lead why).
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
HOOK
cat > .githooks/commit-msg <<'HOOK'
#!/bin/sh
# Shared commit-msg hook: enforce Conventional Commits on the first line of the message.
subject=$(head -n 1 "$1")
case "$subject" in
  "Merge "*) exit 0 ;;          # git's own merge messages
esac
if printf '%s\n' "$subject" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9._/-]+\))?!?: .+'; then
  exit 0
fi
echo "commit-msg: '$subject' is not a Conventional Commit." >&2
echo "  Use: type(scope): description   e.g. feat(cart): add bulk discount" >&2
exit 1
HOOK
chmod +x .githooks/pre-commit .githooks/commit-msg
git config core.hooksPath .githooks
git add .githooks
git commit -q -m "chore: add shared git hooks"
