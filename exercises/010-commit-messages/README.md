# Write commit messages your team will love

Look at the recent history:

```
* Updated the cart file because the TODO was not needed anymore and also some other cleanup
* WIP
* fixed stuff.
* Initial storefront
```

Maya sighs: *"In six months none of this will tell us anything."* She adds the team's commit message
convention to the wiki and asks you to set the example with the change you and Lena paired on this morning.

**Issue #12:** *"Customers can add more items to the cart than we have in stock; the order then fails at
payment."* Your fix (already **staged**): a new `src/stock.js` with `canAdd()`, and `addItem()` now throws
`OUT_OF_STOCK` when a stock table is passed and there isn't enough.

## Your task

Commit the staged changes as **one commit** whose message follows the convention:

1. **Subject line**: at most **50 characters**, starts with a capital letter, **imperative mood**
   ("Add…", "Prevent…" — not "Added…", "Adds…", "Adding…"), **no period** at the end.
2. **Blank line** after the subject.
3. **Body**: explains *what* and *why* (not how), wrapped so **no line is longer than 72 characters**.
4. **Trailers** in the last paragraph:
   - `Closes #12` (GitHub closes the issue when this reaches the default branch)
   - `Co-authored-by: Lena Okafor <lena@brightcart.example>` (gives Lena credit on GitHub)

Don't change the staged code, and don't touch the older commits.

## You'll practice

`git commit` with your editor (not `-m`), the 50/72 rule, imperative subjects, Git trailers,
`git commit --trailer` / `git interpret-trailers`, `commit.template`, and `git log --format`.
