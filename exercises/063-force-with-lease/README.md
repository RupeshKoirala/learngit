# Force-push safely with --force-with-lease

Maya asked you to rebase your PR branch `feature/order-notes` onto the latest `main` before she reviews it.
You already did (`git rebase origin/main`). Now your local branch and the one on origin have **diverged** —
they contain the "same" three commits, but with different hashes:

```
* Add order note lenght limit        <- feature/order-notes (local, rebased)
* Show order notes on receipt
* Add notes field to orders
* Document the order model           <- origin/main
* Round cents before formatting
| * Add order note lenght limit      <- origin/feature/order-notes (old, pre-rebase)
| * Show order notes on receipt
| * Add notes field to orders
|/
* Add order model
```

## Your task

1. Run `git push` and read why it's rejected. Then publish your rebased branch with
   **`--force-with-lease`** (not `--force`).
2. Maya starts reviewing. Run **`./lg event`** — she pushes a fix to *your* branch.
3. Pretend you didn't see her message: you notice the typo **"lenght"** in your last commit message. Fix it with
   `git commit --amend` and push again with `--force-with-lease` — **without fetching first**. Watch the lease
   protect Maya's commit.
4. Now fetch, look at what Maya pushed, and integrate her commit into your branch. Push again (lease again).

When you're done, `feature/order-notes` on origin and locally must be identical and contain, on top of the
latest `main`, exactly four commits: your three (with the message fixed to `Add order note length limit`)
and Maya's `Escape HTML in order notes`. Linear history, no merge commits. Don't touch `main`.

## You'll practice

`git push --force-with-lease`, "stale info" rejections, `git fetch` + `git log HEAD..origin/<branch>`,
integrating someone's commit into a rewritten branch (`cherry-pick` or rebase), and `--force-if-includes`.
