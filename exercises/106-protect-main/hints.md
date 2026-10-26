Two APIs exist. Classic: `PUT repos/{owner}/{repo}/branches/main/protection` (one JSON body with every setting).
Rulesets (newer, can target many branches, stackable, have an "evaluate" mode): `POST repos/{owner}/{repo}/rulesets`.
Pass JSON with `gh api ... --input file.json` (or `--input -` and a heredoc).
---
Classic body (all four top-level keys are required, `null` switches one off):

```
{ "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": { "required_approving_review_count": 0 },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false }
```
---
Ruleset body:

```
{ "name": "protect-main", "target": "branch", "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "bypass_actors": [],
  "rules": [ { "type": "pull_request", "parameters": { "required_approving_review_count": 0,
               "dismiss_stale_reviews_on_push": true, "require_code_owner_review": false,
               "require_last_push_approval": false, "required_review_thread_resolution": false } },
             { "type": "required_linear_history" }, { "type": "non_fast_forward" }, { "type": "deletion" } ] }
```
`gh api repos/{owner}/{repo}/rules/branches/main` shows the rules in effect.
---
The proof:

```
git switch main && git commit --allow-empty -m "try direct push"
git push 2>&1 | tee /dev/stderr | grep 'GH0' > ../106-protect-main/ANSWER
git reset --hard origin/main
```
