# Code review: comments, a suggestion, resolved threads

Lena (frontend) pushed **`feature/free-shipping`** before going on holiday and asked you to open the PR and
get it merged. The spec from Sam (PM) says:

> Orders of **$50.00 or more** ship free. Below that, shipping is $4.99.

```
* Add free shipping threshold   <- origin/feature/free-shipping   (adds src/shipping.js)
* ...                           <- main
```

Read `src/shipping.js` carefully: there's an off-by-one against the spec.

On a solo account GitHub won't let you *Approve* or *Request changes* on your own PR, so you submit a
**Comment** review - the mechanics (line comments, suggestions, threads) are exactly what teams use.

## Your task

1. Open a PR from `feature/free-shipping` into `main` (`gh pr create`).
2. Submit a **review** with **at least one line comment** on `src/shipping.js`, and one of the comments must
   contain a GitHub **suggestion block** (```` ```suggestion ````) that fixes the off-by-one.
3. **Apply the suggestion** (the "Commit suggestion" button, or the same change locally + push), so the PR
   branch has `total >= FREE_SHIPPING_FROM`.
4. **Resolve every review conversation** on the PR.

Merging afterwards is optional.

## You'll practice

PR "Files changed" view, line comments, ```` ```suggestion ```` blocks, Comment vs Approve vs Request changes,
`gh pr review`, `gh api .../pulls/N/reviews`, resolving threads, `gh pr diff`, `gh pr checkout`.
