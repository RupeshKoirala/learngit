# Solution

```bash
cd "$(./lg where)"
git switch main && git pull && git switch -c chore/templates
mkdir -p .github/ISSUE_TEMPLATE

cat > .github/pull_request_template.md <<'EOF'
## What
<!-- What does this PR change? -->

## Why
<!-- Link the issue: Closes #123 -->

## How to test
1.

## Checklist
- [ ] Tests pass (`./test.sh`)
- [ ] Docs / CHANGELOG updated
- [ ] Screenshots for UI changes
EOF

cat > .github/ISSUE_TEMPLATE/bug_report.yml <<'EOF'
name: Bug report
description: Something in the store is broken
labels: ["bug"]
body:
  - type: textarea
    id: steps
    attributes:
      label: Steps to reproduce
      placeholder: "1. Add an item to the cart\n2. ..."
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected vs actual
    validations:
      required: true
  - type: dropdown
    id: area
    attributes:
      label: Area
      options: [Cart, Checkout, Search, Other]
EOF

cat > .github/ISSUE_TEMPLATE/feature_request.yml <<'EOF'
name: Feature request
description: Suggest an improvement
labels: ["enhancement"]
body:
  - type: textarea
    id: problem
    attributes:
      label: What problem does this solve, and for whom?
    validations:
      required: true
EOF

printf '%s\n' "# Last match wins" "*       @$(gh api user -q .login)" "/src/   @$(gh api user -q .login)" > .github/CODEOWNERS
git add .github && git commit -m "Add PR template, issue forms and CODEOWNERS"
git push -u origin HEAD && gh pr create --fill && gh pr merge --squash --delete-branch
gh api repos/{owner}/{repo}/codeowners/errors         # {"errors":[]}
gh issue create --web
```

**Why it works:** GitHub reads these files from the **default branch**: the PR template pre-fills every new
PR body, issue forms render as web forms with validation and apply their labels automatically, and CODEOWNERS
maps paths to owners who are auto-requested as reviewers on PRs touching those paths.

**Real-world notes**
- CODEOWNERS is matched bottom-up: the **last** matching line wins, so put broad rules first. Use teams
  (`@org/team`) rather than people so ownership survives vacations and departures.
- Auto-requests skip the PR author, which is why nothing happens in a solo lab. On a team, combine CODEOWNERS
  with "Require review from Code Owners" in branch protection - now `/src/payments/` can't change without the
  payments team.
- `.github/ISSUE_TEMPLATE/config.yml` with `blank_issues_enabled: false` and `contact_links` (security
  reports, support forum) keeps the tracker clean. Org-wide defaults live in a repo named `.github`.
- Templates are nudges, not gates: keep them short or people delete them. Pair with a PR-title lint or a
  "Definition of Done" checklist that reviewers actually check.
