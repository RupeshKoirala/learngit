# Incident commander: bisect, revert, patch release, postmortem

**INC-311, Sev-1.** `v3.1.0` went to production at 09:12. By 09:40 support had 200 tickets: *"I can't check
out."* At 09:55 Maya pages you: **you're the incident commander.** Ops already rolled production back to
`v3.0.0`, but marketing's big campaign starts tomorrow and needs 3.1's features — so you need a proper fix.

The SRE wrote a repro script, `repro-checkout.sh`, in the sandbox folder (next to `repo/`). It exits `0` when
checkout works, `1` when it's broken and `125` when a commit can't be tested.

```
* feat(checkout): gift message (3.2)          <- main  (3.2 work, not for a patch release)
* feat(loyalty): earn points (3.2)
* chore(release): 3.1.0                       <- release/3.1, tag v3.1.0   (broken)
* ... 8 commits ...                              somewhere in here is the culprit
* chore: initial storefront                   tag v3.0.0                   (works)
```

## Your task

1. Find the commit that broke checkout with `git bisect` between `v3.0.0` (good) and `v3.1.0` (bad).
   Finish the bisect (`git bisect reset`).
2. On `release/3.1`, **revert** the culprit with `git revert` and tag the result `v3.1.1` (**annotated**).
   `v3.1.1` must pass the repro and must not contain any 3.2 work.
3. Make sure `main` gets the fix too (cherry-pick the revert, merge `release/3.1`, or fix forward) — the bug
   must not come back in 3.2. `main` keeps its 3.2 work.
4. Write `INCIDENT.md` at the root of `main` and commit it. It needs the sections **Timeline**,
   **Root cause** and **Resolution** (as Markdown headings). The timeline has at least 3 bullet points. The
   document must mention the culprit commit's hash (7+ characters), `v3.0.0` (last good), `v3.1.0` (broken) and
   `v3.1.1` (fixed).
5. Leave a clean working tree with no bisect in progress.

## You'll practice

`git bisect start/good/bad/run/skip/reset`, `git revert` on a release branch, patch releases, forward-porting,
and writing a blameless postmortem a PM and an exec can read.
