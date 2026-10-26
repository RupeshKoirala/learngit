# One function's whole story

An auditor emails finance: *"Order #4471 was charged $1.99 tax on a $9.99 item. At 20% that's $1.998, which
should round to $2.00. Explain."* Sam (PM) forwards it to you with "can you dig into how `calculateTax`
evolved? I need to answer by lunch."

`src/tax.js` has been touched a dozen times, mostly for *other* functions (`formatTax`, `rateFor`,
`roundCents`). `git log -p src/tax.js` is a wall of unrelated diffs, and `git blame` only shows the last
change per line. You want the history of **one function**, and nothing else.

The auditor also asks about the old EU rate constant `TAX_RATE_EU`. It doesn't exist any more, but it did
in **v1.0**.

## Your task

In `repo` (don't change any commits or branches), write answers into `../ANSWER`, one `key=value` per line:

```
q1=<how many commits changed the calculateTax function, including the one that created it>
q2=<how many files the "rounding" commit (below) changed in total>
q3=<path of the file that contained TAX_RATE_EU in release v1.0>
```

And tag the commit that changed `calculateTax` from rounding to the **nearest** cent to rounding **down** as
**`rounding-change`**. (That's the auditor's answer. Its message says why.)

## You'll practice

`git log -L :<funcname>:<file>` (and `-L <start>,<end>:<file>`), `git show --stat` / `--name-only`, and
`git grep <pattern> <revision>` to search a past version without checking it out.
