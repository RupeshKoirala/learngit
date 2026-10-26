# Rescue a 3-month-old long-lived branch

Dev started `feature/multi-currency` three months ago, then got pulled onto other work. Sam (PM) just
promised multi-currency to a big European customer for next sprint, and Maya asks you to **get the branch
landed**. It's on `origin`, Lena has commits on it too — and she has unpushed local work based on it.

Meanwhile `main` had three months of life: the shell libraries moved from `src/` to `lib/`, `format_price`
learned to format refunds (negative amounts), and more.

```
* feat(cart): cart_empty helper                        <- main, origin/main
* docs: describe search
* feat(search): fuzzy product search
* fix(money): format refunds (negative amounts)        (rewrote format_price)
* refactor: move shell libraries from src/ to lib/
| * docs: describe multi-currency                      <- feature/multi-currency (you're here)
| * test(currency): cover EUR formatting and GBP conversion     (Lena)
| * feat(money): format_price takes a currency
| * feat(currency): exchange rate table
|/
* chore: storefront skeleton with tests
```

## Your task

1. **Decide: merge or rebase?** Write your choice — `merge` or `rebase` — into the file `ANSWER` (in the
   sandbox folder, next to `repo/`). Think about who else has this branch.
2. Integrate `main` into `feature/multi-currency` the way you decided. Resolve everything so that:
   - all code lives in `lib/` (no `src/` folder left), including `lib/currency.sh`;
   - `format_price` handles **both** currencies and refunds, e.g. `format_price -250 GBP` prints `-GBP 2.50`,
     `format_price -150` prints `-$1.50`, `format_price 1999 EUR` prints `EUR 19.99`;
   - `./test.sh` passes and the README keeps both new sections.
3. **Land it:** merge the branch into `main` with a merge commit, so `main`'s first-parent history stays the
   mainline.
4. Push `main` and `feature/multi-currency` to `origin`. Don't rewrite anything that's already on `origin`.
   Leave a clean working tree.

## You'll practice

The merge-vs-rebase decision on shared branches, big-merge conflict types (content, *modify/delete*, *file
location* after a directory rename), semantic conflicts that Git can't see, `git merge --no-ff`, and
`git checkout --ours/--theirs`, `git show :1:path`.
