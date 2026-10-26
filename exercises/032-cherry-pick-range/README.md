# Cherry-pick a range of commits, then combine picks with -n

An accessibility audit of the checkout page is due Friday. Lena already fixed the three findings — but on
her `feature/checkout-redesign` branch, between redesign commits that are nowhere near ready:

```
* Redesign: gradient pay button (DO NOT SHIP yet)   <- feature/checkout-redesign
* a11y: visible focus outline          \
* a11y: label the remove-item button    > the 3 you want (consecutive)
* a11y: add alt text to cart image     /
* Redesign: bigger headings
* Redesign: grid layout for checkout
* Add stock check                      <- main
* Release 2.0.0                        <- release/2.0
* ...
```

Sam (PM) wants the fixes in **both** the 2.0 maintenance line and `main`. The two branches have different
house rules:

- `release/2.0`: Maya's release-notes script lists every commit, so it takes **1:1 copies**.
- `main`: one commit per change request, so the three fixes land as **one combined commit**.

## Your task

1. `release/2.0` gets exactly **3 new commits**: copies of the three `a11y:` commits, same messages, same
   order (oldest first).
2. `main` gets exactly **1 new commit** named `Accessibility fixes for checkout audit` containing all
   three a11y changes and nothing else.
3. No redesign work (`styles/redesign.css`) on either branch; `feature/checkout-redesign` unchanged.
4. Clean working tree, no cherry-pick in progress.

## You'll practice

Range cherry-picks with `A^..B` (and why the `^` matters), `git cherry-pick -n` / `--no-commit` to stack
several picks in the index and commit them once, and `--continue` / `--abort` for multi-commit picks.
