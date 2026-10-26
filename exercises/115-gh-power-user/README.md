# gh power user

Seniors live in the terminal: they review a PR without touching the browser, watch CI from the shell, and
answer questions about the repo with one `gh api` line. Practise the moves you'll use every day.

Jo (new hire) opened **"Add loyalty points"** from `review/loyalty-points`. The spec says *1 point per whole
dollar*, but `pointsFor(1999)` returns `19.99`.

## Your task

1. **Alias:** create a gh alias **`prs`** that expands to `pr list --author @me` (try `gh prs`).
2. **Checkout a PR by number:** get Jo's branch locally with **`gh pr checkout <N>`** (you don't have it yet).
   Local `review/loyalty-points` must track `origin/review/loyalty-points`.
3. **Fix + watch CI:** make `pointsFor` return whole points (`Math.floor`), commit, push, and follow the CI run
   with **`gh run watch`** (or `gh pr checks --watch`). The run for your new commit must be **green**.
   (No CI yet? Do exercise 107 first.)
4. **`gh api` + `--jq`:** count how many pull requests have been **merged** in your lab so far and write the
   number into **`merged-prs`** in this exercise's sandbox (from the lab: `../115-gh-power-user/merged-prs`).
5. **`gh search`:** find **octocat's most-starred repository** and write its full name (`owner/name`) into
   **`top-octocat-repo`** in the same folder.

## You'll practice

`gh alias set`, `gh pr checkout`, `gh run list / watch / view`, `gh pr checks --watch`, `gh api` with
`--jq` and `--paginate`, `gh search repos --sort stars --json`, `{owner}/{repo}` placeholders.
