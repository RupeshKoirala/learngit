```yaml
name: CI
on:
  pull_request:
  push:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./test.sh
```
Branch `ci/add-workflow`, commit the file, push, `gh pr create --fill`, `gh pr checks --watch`, `gh pr merge --squash`.
---
`gh pr create --head feature/bulk-discount --base main --fill`, then `gh pr checks <N> --watch`.
`gh run list --branch feature/bulk-discount` and `gh run view <run-id> --log-failed` show why it's red.
(If the PR was opened before CI was on main, push any new commit to trigger a run.)
---
On `feature/bulk-discount`, make `src/bulk.js` return `Math.round(total * 0.9)` and delete the `// BUG` line.
Commit, `git push`, `gh pr checks <N> --watch` -> green.
---
Classic protection: `gh api -X PATCH repos/{owner}/{repo}/branches/main/protection/required_status_checks
-F strict=true -f 'contexts[]=test'` (if status checks were never enabled, PUT the full protection from 106
with `"required_status_checks": {"strict": true, "contexts": ["test"]}`).
Ruleset: add `{"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":true,
"required_status_checks":[{"context":"test"}]}}` to its `rules` and `PUT repos/{owner}/{repo}/rulesets/<id>`.
