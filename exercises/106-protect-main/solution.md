# Solution

```bash
cd "$(./lg where)"
# GitHub Free + private? -> gh repo edit --visibility public --accept-visibility-change-consequences
```

**Option A - classic branch protection**

```bash
gh api -X PUT repos/{owner}/{repo}/branches/main/protection --input - <<'EOF'
{ "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": { "required_approving_review_count": 0, "dismiss_stale_reviews": true },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false }
EOF
gh api repos/{owner}/{repo}/branches/main/protection --jq '{admins: .enforce_admins.enabled, linear: .required_linear_history.enabled}'
```

**Option B - a ruleset**

```bash
gh api repos/{owner}/{repo}/rulesets --input - <<'EOF'
{ "name": "protect-main", "target": "branch", "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "bypass_actors": [],
  "rules": [
    { "type": "pull_request", "parameters": { "required_approving_review_count": 0,
      "dismiss_stale_reviews_on_push": true, "require_code_owner_review": false,
      "require_last_push_approval": false, "required_review_thread_resolution": false } },
    { "type": "required_linear_history" },
    { "type": "non_fast_forward" },
    { "type": "deletion" } ] }
EOF
gh api repos/{owner}/{repo}/rules/branches/main --jq '.[].type'
```

**Prove it**

```bash
git switch main
git commit --allow-empty -m "try a direct push"
git push
# remote: error: GH006: Protected branch update failed for refs/heads/main.     (classic)
# remote: error: GH013: Repository rule violations found for refs/heads/main.   (ruleset)
echo "remote: error: GH006: Protected branch update failed for refs/heads/main." > ../106-protect-main/ANSWER
git reset --hard origin/main
```

**Why it works:** protection is evaluated on GitHub's side for every push. A push that updates `main`
directly isn't a merged PR, so it's rejected; with `enforce_admins` / no bypass actors the repo owner is
included. Rejected pushes change nothing on the server, so resetting your local branch is the only cleanup.

**Real-world notes**
- Team defaults a lead would set: **1-2 approvals**, **dismiss stale approvals** on new pushes,
  **require review from Code Owners** (108), **require conversation resolution**, **required status checks**
  with "branches must be up to date", linear history (if you squash/rebase), no force pushes, no deletions.
- **Rulesets vs classic:** rulesets can target many branches/tags with patterns (`release/*`, `v*` tags),
  layer (org-wide + repo), run in **evaluate** mode first, and allow precise bypass lists (e.g. a release bot
  or "admins via PR only"). New setups should prefer rulesets; classic still works everywhere.
- Keep an emergency path: a bypass for a small admin team beats disabling protection in a panic. Audit it.
- Script it (or Terraform `github_branch_protection` / `github_repository_ruleset`) so every new repo gets the
  same rules - org rulesets do this centrally.
- Solo/side projects: a PR-required rule still pays off - CI runs on every change, and the PR is the changelog.
