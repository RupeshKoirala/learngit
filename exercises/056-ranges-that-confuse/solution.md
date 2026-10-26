# Solution

```bash
git log --oneline main..origin/main              # what a pull brings in
git rev-list --count main..origin/main           # q1 = 3
git rev-list --count origin/main..main           # q2 = 2   (what a push would send)
git log --oneline --left-right main...origin/main
# > e3d6253 Brand link colour
# > f933ec2 Clarify price units
# > cd12d84 Fix VAT rounding on invoices
# < 1a2b3c4 Add release checklist
# < 5d6e7f8 Announce gift cards in README
git rev-list --count main...origin/main          # q3 = 5   (= q1 + q2)

git rev-list --count main..feature/gift-cards                  # 6: includes Lena's 2 + the merge
git rev-list --count --first-parent main..feature/gift-cards   # q4 = 4: your 3 + the merge commit

git rev-list --count origin/release/1.3 ^main ^origin/main     # q5 = 3

git log --oneline --cherry-mark origin/main...origin/release/1.3
# + e3d6253 Brand link colour
# + f933ec2 Clarify price units
# = cd12d84 Fix VAT rounding on invoices             <- same patch as e380146 below
# + 034423c Fix crash on empty cart                  <- not on main in any form
# = e380146 Fix VAT rounding on invoices
# + 68f25fe Bump version to 1.3.0                    <- release-only, never port
# (add --right-only to see only the release side; --cherry-pick hides the "=" pairs)
git tag needs-port 034423c
```

`../ANSWER`:
```
q1=3
q2=2
q3=5
q4=4
q5=3
```

**Why it works**
- **`A..B`** = `B ^A`: everything reachable from B, minus everything reachable from A. It's *asymmetric*:
  `main..origin/main` (incoming) and `origin/main..main` (outgoing) answer different questions.
- **`A...B`** in `git log` = reachable from either, minus the merge base's history, i.e. both sides
  since they diverged. `--left-right` tells you which side each commit is on.
- **Trap: in `git diff` the dots mean something else.** `git diff A..B` is just `git diff A B`.
  `git diff A...B` is "what B changed since it branched from A", which is what a PR page shows. So the
  three dots mean different things in log and diff.
- **`--first-parent`** walks only the first parent of merges. On a branch that merges others in, that's the
  branch's own story. On `main` with merge-commit PRs, it's one line per PR.
- **`^ref`** excludes everything reachable from `ref`, and you can stack as many as you like. `A..B` is only
  the two-ref shorthand.
- **`--cherry-pick` / `--cherry-mark`** compare *patch IDs* (a hash of the diff), so a cherry-picked commit
  counts as "the same" even with a different commit hash.

**Real-world notes**
- Before pulling, do what you just did: `git fetch`, then `git log --oneline main..origin/main`. You see
  what's coming and can decide between merge, rebase or waiting, without surprises.
- Before pushing: `git log --oneline origin/main..main`, i.e. "what am I about to publish?" Many seniors
  alias these as `incoming` and `outgoing`.
- Release managers live on `--cherry-mark`. "Is every hotfix from release/1.3 also on main?" is a
  release checklist item, and forgetting one means the bug comes back in the next release (a regression).
- `git cherry -v origin/main origin/release/1.3` is an older, terser command for the same question (`-` =
  already upstream, `+` = not yet).
- For PMs, "what's in this release" is a range: `git log --oneline v1.2..v1.3`. See exercise 059.
