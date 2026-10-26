```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```
Branch, commit, push, `gh pr create --fill`, merge.
---
These settings are PUT endpoints with no body:
`gh api -X PUT repos/{owner}/{repo}/vulnerability-alerts` and `gh api -X PUT repos/{owner}/{repo}/automated-security-fixes`.
Reading them back: `gh api repos/{owner}/{repo}/vulnerability-alerts` (204 = on, 404 = off).
---
Secret scanning lives in the repo's `security_and_analysis` object:

```
gh api -X PATCH repos/{owner}/{repo} --input - <<'EOF'
{"security_and_analysis": {"secret_scanning": {"status": "enabled"},
                           "secret_scanning_push_protection": {"status": "enabled"}}}
EOF
```
---
Alerts can take a few minutes to appear:
`gh api repos/{owner}/{repo}/dependabot/alerts --jq '.[] | {number, state, package: .dependency.package.name, severity: .security_advisory.severity}'`
