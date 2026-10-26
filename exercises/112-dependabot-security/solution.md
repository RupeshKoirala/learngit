# Solution

```bash
cd "$(./lg where)"
git switch main && git pull && git switch -c chore/dependabot
mkdir -p .github
cat > .github/dependabot.yml <<'EOF'
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
EOF
git add .github && git commit -m "Configure Dependabot version updates"
git push -u origin HEAD && gh pr create --fill && gh pr merge --squash --delete-branch

gh api -X PUT repos/{owner}/{repo}/vulnerability-alerts
gh api -X PUT repos/{owner}/{repo}/automated-security-fixes
gh api -X PATCH repos/{owner}/{repo} --input - <<'EOF'
{"security_and_analysis": {"secret_scanning": {"status": "enabled"},
                           "secret_scanning_push_protection": {"status": "enabled"}}}
EOF
gh api repos/{owner}/{repo}/dependabot/alerts --jq '.[] | [.number, .dependency.package.name, .security_advisory.severity] | @tsv'
gh pr list --author app/dependabot
```

**Why it works:** the dependency graph parses `package.json` (and lockfiles, workflows) and matches versions
against the GitHub Advisory Database -> **alerts**. **Security updates** open a PR bumping a vulnerable
dependency to the minimal fixed version. **Version updates** (`dependabot.yml`) open routine bump PRs on a
schedule, vulnerable or not. Secret scanning searches pushed content for known token formats; **push
protection** rejects the push *before* the secret lands on GitHub.

**Push protection in practice:** if `git push` is blocked with "GH013 ... Secret detected", the secret is in
a local commit. Remove it from history (`git commit --amend`, or `git rebase -i` and edit that commit), move
it to an env var / secret manager, and push again. If it ever reached a remote: **rotate the secret first** -
deleting the commit doesn't un-leak it.

**Real-world notes**
- Dependabot PRs are only safe to merge because CI runs on them (107). Group minor/patch bumps to cut noise,
  and give someone the weekly "dependency duty".
- Triage alerts by reachability and severity; dismiss with a reason ("not used in production") so the
  decision is recorded.
- Org level: enable these for all repos by default, add **CodeQL** code scanning, a `SECURITY.md` that says
  how to report vulnerabilities, and private vulnerability reporting.
- Never commit `.env` files (the lab's `.gitignore` already excludes it); use GitHub Actions secrets / OIDC.
