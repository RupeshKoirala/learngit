# git blame like a detective

Support is flooded with tickets: *"My $42 order used to ship free, now I pay $4.99!"* Sam (product manager)
pings you: **"Who changed the free-shipping threshold, and why? Was it on purpose?"** While you're in there,
Maya (tech lead) adds: *"And find out who actually came up with the $14.99 express rate. I want to ask them
about it before we change it."*

You open `src/shipping.js` and run `git blame`. Every interesting line says **release-bot**,
`Format all code with prettier`. Thanks, bot. Under that commit the history is even more disguised:

```
* Point README readers to #shipping
* Add placeholder shipping tests
* Format all code with prettier          <- bot: quotes + semicolons on every line
* Add formatDiscount helper
* Use 2-space indentation everywhere     <- Jo: whitespace-only change
* Raise free-shipping threshold to $50
* Document shipping in README
* Extract shipping rules into src/shipping.js   <- Maya moved code out of src/cart.js
* ...
* Initial storefront
```

## Your task

Work in `repo` (stay on `main`):

1. Tag the commit that really set `FREE_SHIPPING_THRESHOLD = 5000` as **`threshold-change`**.
2. Its commit message references a ticket. Write the ticket ID (e.g. `ABC-123`) into the file `ANSWER` in the
   sandbox folder (one level above `repo`, i.e. `../ANSWER`).
3. Tag the commit that **originally wrote** the express rule
   `return cart.express ? 1499 : 499` as **`express-origin`**: not the commit that reformatted it,
   re-indented it, or moved it to another file.
4. Make the bot's reformat stop polluting blame for the whole team:
   - create **`.git-blame-ignore-revs`** at the repo root containing the **full** hash of the
     `Format all code with prettier` commit (comments starting with `#` are allowed),
   - commit it on `main`,
   - and set this repo's `blame.ignoreRevsFile` config to `.git-blame-ignore-revs`, so a plain
     `git blame src/shipping.js` shows Dev's change on the threshold line.

Don't rewrite any existing history.

## You'll practice

`git blame`, `-L`, `-w` (ignore whitespace), `-C` / `-M` (follow moved and copied code), blaming *from a
parent* (`git blame <rev>^ -- <file>`), `--ignore-rev`, `--ignore-revs-file` and `blame.ignoreRevsFile`,
and reading the *why* in a commit message with `git show`.
