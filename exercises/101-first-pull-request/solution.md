# Solution

```bash
cd "$(./lg where)"
git switch main && git pull
gh issue list                                   # say it's #1
git switch -c feature/price-separators
```

`src/price.js`:

```js
// Price formatting
function formatPrice(cents) {
  return '$' + (cents / 100).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

module.exports = { formatPrice };
```

```bash
./test.sh
git commit -am "Show thousands separators in prices"
git push -u origin feature/price-separators
gh pr create --base main --title "Show thousands separators in prices" --body "$(cat <<'EOF'
## What
`formatPrice()` adds thousands separators: `$123,456.00`.

## Why
Large totals were hard to read. Closes #1

## How to test
1. `./test.sh`
2. `node -e "console.log(require('./src/price').formatPrice(12345600))"` prints `$123,456.00`
EOF
)"
gh pr view --web
gh pr merge --squash --delete-branch            # optional
```

**Why it works:** `push -u` creates the remote branch and records it as the upstream, so later `git push` /
`git pull` / `gh pr create` know where the branch lives. `gh pr create` calls the GitHub API with the current
branch as head. A closing keyword followed by `#N` links the issue to the PR ("Development" sidebar) and
closes it when the PR is merged into the default branch.

**Real-world notes**
- The description is the most-read thing you write all week: reviewers, the PM, and future-you running
  `git blame` -> PR. Lead with *what* and *why*, give a test recipe, add screenshots for UI changes, and call
  out risky bits ("touches checkout - please look at X").
- Keep PRs small (a few hundred lines). Large PRs get rubber-stamped, small ones get real review.
- `gh pr create --fill` uses your commit message(s) as title/body; `--web` opens the browser form; `--draft`
  says "not ready yet" (exercise 113); `--reviewer`, `--assignee @me`, `--label` save clicks.
- Branch naming (`feature/…`, `fix/…`, `chore/…`, or `TICKET-123-short-name`) is a team convention - follow
  the one in CONTRIBUTING.md.
- A repo-level PR template (exercise 108) pre-fills the What/Why/How-to-test sections for everyone.
