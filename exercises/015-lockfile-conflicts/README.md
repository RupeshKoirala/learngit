# Conflicts in generated files: lockfiles

You're adding Markdown rendering for product reviews (`feature/review-markdown`, new dependency `marked`).
Meanwhile Lena merged "show review dates" to `main` (new dependency `dayjs`). Your PR now conflicts.

```
* Show review dates                  <- main  (Lena)
* Add dayjs dependency
| * Render review text as Markdown   <- feature/review-markdown (HEAD, you)
| * Add marked dependency
|/
* Brightcart 1.5.0
```

Two kinds of files will conflict, and they need **different** treatment:

- `package-lock.json` is **generated** by `./tools/lock.sh` (our stand-in for `npm install`) from
  `package.json`. It contains a hash over *all* dependencies, so any two dependency changes conflict. Nobody
  should hand-edit it — and neither side's version is correct for the merged result.
- `src/product-page.js` is real code that both of you changed. That one needs a human.

## Your task

On `feature/review-markdown`, merge `main` and resolve it like a senior would:

1. `package.json` — check that it merged cleanly and lists **both** `dayjs` and `marked`.
2. `package-lock.json` — take **one side wholesale** (`--ours` or `--theirs`, doesn't matter), then
   **regenerate** it with `./tools/lock.sh` so it matches the merged `package.json` exactly.
3. `src/product-page.js` — resolve by hand: require **both** libraries, and render the review as Markdown
   (`marked.parseInline(review.text)`) **followed by** the formatted date (`dayjs(review.date)…`).
4. Finish the merge commit. `main` must not change. End with a clean working tree.

## You'll practice

`git checkout --ours/--theirs <file>` (a.k.a. `git restore --ours/--theirs`) during a merge, why generated
files are regenerated rather than merged, `git diff` on a conflicted file, and resolving the real code by hand.
