# Solution

```bash
cd "$(./lg where)"
git switch main && git pull

git switch -c stack/1-tax-calc
cat > src/tax.js <<'EOF'
// Sales tax
function addTax(cents, rate) {
  return Math.round(cents * (1 + rate));
}

module.exports = { addTax };
EOF
git add src/tax.js && git commit -m "Add sales tax calculation"
git push -u origin HEAD
gh pr create --draft --base main --title "Add sales tax calculation" --body "Part 1/2. Early feedback welcome."

git switch -c stack/2-tax-display
cat > src/price-with-tax.js <<'EOF'
const { addTax } = require('./tax');
const { formatPrice } = require('./price');

function priceWithTax(cents, rate) {
  return formatPrice(addTax(cents, rate));
}

module.exports = { priceWithTax };
EOF
git add src/price-with-tax.js && git commit -m "Show prices including tax"
git push -u origin HEAD
gh pr create --base stack/1-tax-calc --title "Show prices including tax" --body "Part 2/2, stacked on #<PR1>."

gh pr ready <PR1>
gh pr merge <PR1> --squash --delete-branch       # GitHub retargets PR 2 to main
gh pr view <PR2> --json baseRefName,commits      # base main, but 2 commits now
gh pr edit <PR2> --base main                     # only if it wasn't retargeted

git fetch origin
git switch stack/2-tax-display
git rebase --onto origin/main stack/1-tax-calc   # local stack/1 still points at the old A
git push --force-with-lease
gh pr view <PR2> --json commits,mergeable        # 1 commit, MERGEABLE
```

**Why it works:** a PR shows the commits in its head that aren't in its base. Stacked on `stack/1`, PR 2
shows only B. After a squash merge, `main` has A' (same change, new hash), so from `main`'s point of view A is
still "new" and PR 2 shows A + B (and may conflict). `rebase --onto origin/main stack/1-tax-calc` takes the
commits *after* the old A (just B) and replays them on `main`, which already contains A'.

**Real-world notes**
- Drafts: CODEOWNERS aren't requested and the PR can't be merged until it's marked ready - perfect for "is
  this the right approach?" and for running CI early.
- Stacks keep reviews small while you keep moving. Keep each PR independently reviewable, say "Part 2/3,
  stacked on #41" in the description, and merge bottom-up.
- With **merge commits** (or rebase-merge of unchanged commits) the dance is simpler - squash is what forces
  the `--onto` step. `git rebase --update-refs` (Git 2.38+) moves every branch of a local stack in one go;
  tools like Graphite, git-town, `git-branchless` or `spr` automate whole stacks.
- Turn on "Automatically delete head branches" (104) - GitHub then retargets dependent PRs for you.
