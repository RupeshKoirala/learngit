# Your first pull request with gh

Sam (PM) just filed an issue in your lab: **"Show thousands separators in prices"** (`gh issue list`).
`formatPrice(12345600)` currently returns `$123456.00`; it should return `$123,456.00`.

At Brightcart nothing lands on `main` without a pull request, and a PR description is for the *reviewer*:
what changed, why, and how they can check it in two minutes.

```
* Add package.json and build script   <- main, origin/main
```

## Your task

1. Create a branch **`feature/price-separators`** from an up-to-date `main`.
2. Change `src/price.js` so prices get thousands separators (any working approach). Commit with a good message.
3. Push the branch **and set its upstream** (local `feature/price-separators` tracks `origin/feature/price-separators`).
4. Open a pull request into `main` **with `gh pr create`** (not as a draft):
   - a descriptive title (not just the branch name),
   - a body with three sections: **What**, **Why**, **How to test**,
   - and a line that will **close the issue** when merged (`Closes #<issue number>`).

You may merge it once `./lg check` passes (or leave it open - both are fine).

## You'll practice

`git switch -c`, `git push -u`, `gh pr create --title --body` (or `--body-file`, or the editor), closing
keywords, `gh pr view --web`, `gh pr status`.
