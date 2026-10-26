# Case-only renames that confuse macOS and Windows

Linux CI is red: `Error: Cannot find module './utils'`. Lena's new `src/checkout.js` does
`require('./utils')`, but the file in Git is `src/Utils.js`. On her Mac it worked — macOS and Windows disks are
**case-insensitive**, Linux is not. While you're at it, Maya wants the docs file to be `README.md`, not `readme.md`.

```
* Add checkout quantity limits   <- main   (src/checkout.js requires './utils')
* Initial storefront                       (readme.md, src/Utils.js; src/cart.js requires './Utils')
```

The trap: on a Mac, `mv readme.md README.md` looks like it worked, but `git status` says nothing changed —
Git (with `core.ignorecase=true`) still has `readme.md` in its index, and every Linux checkout keeps the old name.

## Your task

On `main`, in one or more new commits:

1. Rename `readme.md` → `README.md` and `src/Utils.js` → `src/utils.js` **in Git's index** (and on disk). The index
   must contain only the new names (`git ls-files`), and the contents must be unchanged.
2. Git must see them as pure renames (100 % similar) when comparing the old tip with your result.
3. Make every `require` use `'./utils'` — no `'./Utils'` left anywhere.
4. Don't rewrite existing history; clean working tree.

## You'll practice

`git mv -f`, the two-step rename (`A → tmp → a`), `git ls-files`, `core.ignorecase`, and `git diff -M --name-status`.
