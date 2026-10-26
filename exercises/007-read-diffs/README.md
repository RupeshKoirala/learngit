# Read diffs like a reviewer

You're on review duty today. Before you approve anything, Maya wants you to be fluent in *reading* changes:
what's staged, what isn't, what a branch really changes, and what changed between two releases.

```
* Prepare formatPrice for currencies        <- main (HEAD)
| * Document gift cards                     <- feature/gift-cards
| * Point cart to gift cards
| * Add gift card redemption
|/
* Add removeItem and isEmpty                <- tag v1.1
* Support cart-level discounts in total
* Initial storefront                        <- tag v1.0
```

Your working tree on `main` also has uncommitted changes — some staged, some not.

## Your task

Answer four questions by filling in the `ANSWER` file in the sandbox folder (one level above `repo/`;
it's already there with empty `q1=` … `q4=` lines):

- **q1** — Which file has changes that are **staged** *and* **further unstaged** changes on top?
  (give the path, e.g. `src/foo.js`)
- **q2** — In `README.md` exactly **one word** was replaced in your unstaged changes. What is the **new**
  word?
- **q3** — How many files would the pull request for `feature/gift-cards` → `main` show as changed?
  (careful: `main` has moved on since the branch was created)
- **q4** — How many lines were **added** to `src/cart.js` between tags `v1.0` and `v1.1`?

**Don't change anything** in the repo: no commits, and keep your staged and unstaged changes exactly as
they are. Reading diffs should never modify state.

## You'll practice

`git diff` vs `git diff --staged` (`--cached`), `git diff A B` vs `git diff A...B`, `--stat`,
`--numstat`, `--name-only`, `--word-diff`, and limiting a diff to a path with `-- <path>`.
