# GitHub Actions CI

`./test.sh` exists, but nobody runs it before merging. Dev just pushed **`feature/bulk-discount`** and it
breaks the tests (try: `git switch feature/bulk-discount && ./test.sh`). Time for CI, so robots say "no" before
humans have to.

## Your task

1. Through a PR (main is protected), add **`.github/workflows/ci.yml`** that runs `./test.sh` on
   **`pull_request`** and on **`push` to `main`**, in a job with the id **`test`** on `ubuntu-latest`.
   Merge it. The push to `main` must produce a **green** CI run.
2. Open a PR for `feature/bulk-discount`. Watch its check go **red** (`gh pr checks`, `gh run view --log-failed`).
3. Fix the bug on that branch (10% once, and remove the `BUG` marker), push, and watch it go **green**.
4. Make the check **required** on `main`: a required status check named **`test`** (in your branch protection
   or ruleset from 106). Merging the bulk-discount PR afterwards is optional.

> Pushing workflow files needs the `workflow` token scope: if the push is refused, `gh auth refresh -s workflow`.

## You'll practice

Workflow YAML (`on`, `jobs`, `runs-on`, `steps`, `actions/checkout`), `gh run list / watch / view --log-failed`,
`gh pr checks --watch`, required status checks via `gh api`.
