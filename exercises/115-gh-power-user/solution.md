# Solution

```bash
cd "$(./lg where)"
gh alias set prs 'pr list --author @me'
gh prs

gh pr list                                   # Jo's PR, say #21
gh pr checkout 21                            # creates review/loyalty-points tracking origin
# src/loyalty.js:  return Math.floor(totalCents / 100);
git commit -am "Award whole loyalty points only"
git push
gh run list --branch review/loyalty-points --limit 3
gh run watch                                 # or: gh pr checks 21 --watch
gh pr review 21 --comment -b "Pushed a fix for whole points - thanks Jo!"   # optional

gh api 'repos/{owner}/{repo}/pulls?state=closed&per_page=100' \
  --jq '[.[] | select(.merged_at != null)] | length' > ../115-gh-power-user/merged-prs
gh search repos --owner octocat --sort stars --order desc --limit 1 \
  --json fullName --jq '.[0].fullName' > ../115-gh-power-user/top-octocat-repo
```

**Why it works:** `gh pr checkout` looks up the PR's head repo and branch, fetches it, and creates a local
branch with the right upstream - for PRs from forks too, where you'd otherwise add a remote by hand.
`gh run watch` polls the Actions API until the run finishes. `gh api` adds auth, the base URL and
`{owner}/{repo}` from the current repo; `--jq` runs a jq program on the JSON response.

**More moves worth knowing**
- `gh pr status`, `gh pr diff 21`, `gh pr view 21 --comments`, `gh pr merge --auto --squash` (merges when
  checks pass), `gh pr create --fill --web`.
- `gh run view --log-failed`, `gh run rerun --failed`, `gh workflow run deploy.yml -f env=staging`.
- `gh api graphql -f query='...'` for things REST can't do (review threads, projects). `--paginate --slurp`
  (newer gh) combines pages before `--jq` runs.
- Shell aliases: `gh alias set --shell co 'gh pr list | fzf | cut -f1 | xargs gh pr checkout'`.
- `gh search code 'formatPrice' --owner my-org`, `gh search prs --review-requested @me --state open`
  (your review inbox), `gh search issues --assignee @me --state open` (your to-do list across repos).
- `gh extension install` adds subcommands (e.g. dashboards, stacked PR tools). `gh browse src/cart.js:10`
  opens a file at a line - perfect for pasting links in chat.
