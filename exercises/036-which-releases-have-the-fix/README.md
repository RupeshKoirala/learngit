# Which releases contain this fix? Find and close backport gaps

You're the release captain for the week. Two questions land in the team channel:

> **Sam (PM):** A 2.x customer in California says their tax totals are off by a cent. Maya fixed the tax
> rounding on `main` ages ago — which **2.x release** first has it? I need to tell them which version to
> install.
>
> **Maya (lead):** Also, did every `fix:` on `main` since 2.0.0 actually make it into `release/2.x`? Last
> quarter we found out the hard way that one didn't.

```
* feat: wishlist                                       <- main
* Release 3.0.0                (v3.0.0)
* chore: bump test runner
* fix: cart badge count off by one
* fix: round CA sales tax to the nearest cent
* feat: dark mode
* fix: retry payment on gateway timeout
* feat: gift cards
| * Round tax correctly (backport for 2.x customers)  (v2.0.2)  <- release/2.x
| * fix: retry payment on gateway timeout               (v2.0.1)
|/
* Release 2.0.0                (v2.0.0)
```

Trap: `git tag --contains <fix>` only finds tags that contain **that exact commit**. A backport is a
*copy* with a different hash (sometimes even a different message), so it answers "only v3.0.0". Wrong
answer for a 2.x customer.

## Your task

1. Write the **oldest release tag** that contains Maya's CA tax rounding fix into the file `ANSWER` in the
   sandbox folder (next to `repo/`), e.g. `echo v9.9.9 > ../ANSWER`.
2. Find every `fix:` commit on `main` that has **no equivalent** on `release/2.x`. Backport it to
   `release/2.x` with `-x` (one commit per missing fix, nothing else), then tag the new tip **`v2.0.3`**.
3. Features (`feat:`), chores and release commits stay off `release/2.x`. `main` unchanged.
4. Clean tree, no cherry-pick in progress.

## You'll practice

`git branch --contains` / `git tag --contains` (and their blind spot), `git cherry -v`,
`git log --cherry-pick --left-right` / `--cherry-mark`, `git log --grep "cherry picked from"`, patch-ids.
