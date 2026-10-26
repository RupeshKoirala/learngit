# Solution

```bash
cd "$(./lg where)"
git switch main && git pull
git switch -c ci/add-workflow
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'EOF'
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
EOF
git add .github && git commit -m "Run tests in CI"
git push -u origin HEAD
gh pr create --fill && gh pr checks --watch
gh pr merge --squash --delete-branch
gh run list --branch main --limit 3          # the push run -> completed success

gh pr create --head feature/bulk-discount --base main --fill
gh pr checks <N> --watch                     # X test  fail
gh run view --log-failed                     # "tests FAILED"
git switch feature/bulk-discount && git pull
# src/bulk.js: remove the BUG line, return Math.round(total * 0.9)
git commit -am "Apply bulk discount once" && git push
gh pr checks <N> --watch                     # ✓ test

# classic protection
gh api -X PATCH repos/{owner}/{repo}/branches/main/protection/required_status_checks \
  -F strict=true -f 'contexts[]=test'
# or ruleset: GET repos/{owner}/{repo}/rulesets/<id>, add the required_status_checks rule, PUT it back
```

**Why it works:** a workflow in `.github/workflows/` on the default branch (and in the PR's merge result)
subscribes to events. `pull_request` runs on the PR's *merge* commit, so CI tests what main would look like.
Each job reports a check named after the job id (`test`); a required status check makes GitHub refuse merges
until a check with that name is green on the PR's latest commit.

**Real-world notes**
- Required check names must be **stable**: renaming the job (or using a matrix: `test (18)`, `test (20)`)
  silently changes the context and blocks every PR. Many teams add a final "ci-ok" job that `needs:` the
  others and require only that.
- Keep CI fast (< 10 min): cache dependencies (`actions/setup-node` with `cache: npm`), split jobs, run the slow
  suite nightly. Use `concurrency: { group: ci-${{ github.ref }}, cancel-in-progress: true }`.
- Security: pin third-party actions to a commit SHA, set `permissions: contents: read` at the top, and never
  echo secrets. `pull_request` from forks gets no secrets - by design.
- "strict" (branch must be up to date) catches semantic conflicts but forces many re-runs; merge queues
  (`merge_group` event) solve that at scale.
- Red main is everyone's emergency: revert first (110), debug later.
