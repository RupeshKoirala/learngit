`cd "$(./lg where)"`, then `git switch main && git pull` and `git switch -c feature/price-separators`.
`gh issue list` shows the issue number you'll need.
---
One way to format: `(cents / 100).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })`.
Commit, then `git push -u origin feature/price-separators` (`-u` = `--set-upstream`).
---
`gh pr create` without flags asks interactively. Non-interactive: `--base main --title "..." --body-file pr.md`.
GitHub only links + auto-closes the issue for keywords like `Closes #12`, `Fixes #12`, `Resolves #12`.
---
```
cat > /tmp/pr.md <<'EOF'
## What
formatPrice() now adds thousands separators: $123,456.00

## Why
Big totals were hard to read (Closes #12)

## How to test
./test.sh, then: node -e "console.log(require('./src/price').formatPrice(12345600))"
EOF
gh pr create --base main --title "Show thousands separators in prices" --body-file /tmp/pr.md
```
(use your real issue number)
