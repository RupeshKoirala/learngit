# Templates & ownership

Brightcart is hiring. New people open PRs with empty descriptions and issues that say "it's broken". And
nobody knows who should review changes to checkout. Fix the *process* with files in the repo:

## Your task

Through **one PR** (main is protected), add to `main`:

1. **`.github/pull_request_template.md`** with the sections **What**, **Why**, **How to test** and a short
   checklist (`- [ ] tests pass`, ...).
2. Two **issue forms** (YAML, not Markdown templates):
   - **`.github/ISSUE_TEMPLATE/bug_report.yml`** - has `name`, `description`, `labels: ["bug"]` and a `body`
     with at least one `textarea` (e.g. steps to reproduce, required).
   - **`.github/ISSUE_TEMPLATE/feature_request.yml`** - has `name`, `description`, a `body`, and
     `labels: ["enhancement"]`.
3. **`.github/CODEOWNERS`** that makes **you** (`@<your-login>`) the owner of everything, and explicitly of
   `/src/`. GitHub must report **no errors** in it.

Then open GitHub's "New issue" page (`gh issue create --web`) and see your forms.

## You'll practice

`pull_request_template.md`, issue forms (`type: textarea | input | dropdown | checkboxes`, `validations`),
`config.yml`, CODEOWNERS patterns and precedence, `gh api repos/{owner}/{repo}/codeowners/errors`.
