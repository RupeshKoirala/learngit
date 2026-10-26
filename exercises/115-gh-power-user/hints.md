`gh alias set prs 'pr list --author @me'` - then `gh alias list`. `gh pr list` shows Jo's PR number;
`gh pr checkout <N>` creates the local branch with its upstream set.
---
Edit `src/loyalty.js`: `return Math.floor(totalCents / 100);`, commit, `git push`, then
`gh run list --branch review/loyalty-points --limit 3` and `gh run watch` (it lets you pick the run).
---
`gh api` speaks REST and filters with jq (no jq install needed):

```
gh api 'repos/{owner}/{repo}/pulls?state=closed&per_page=100' --jq '[.[] | select(.merged_at != null)] | length'
```
Careful with `--paginate`: the `--jq` filter runs once **per page** (you'd get several numbers). Cross-check:
`gh pr list --state merged --limit 500 --json number --jq length`.
---
```
gh search repos --owner octocat --sort stars --order desc --limit 1 --json fullName --jq '.[0].fullName' > ../115-gh-power-user/top-octocat-repo
gh pr list --state merged --limit 500 --json number --jq length > ../115-gh-power-user/merged-prs
```
