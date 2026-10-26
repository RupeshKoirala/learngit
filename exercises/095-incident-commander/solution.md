# Solution

```bash
# 1. Find the culprit — let Git do the binary search
git bisect start v3.1.0 v3.0.0          # bad first, then good
git bisect run ../repro-checkout.sh     # exit 0 good, 1 bad, 125 skip
# -> a9be5f6 is the first bad commit: "refactor(checkout): use MIN_ITEMS consistently"
git show a9be5f6                        # -ge became -gt: 1-item carts rejected
git bisect reset

# 2. Patch release from the release branch
git switch release/3.1
git revert a9be5f6                      # keeps "This reverts commit <full hash>."
../repro-checkout.sh                    # checkout OK
git tag -a v3.1.1 -m "Brightcart 3.1.1 (INC-311)"

# 3. Forward-port so 3.2 doesn't re-break it
git switch main
git cherry-pick -x release/3.1          # the revert commit
../repro-checkout.sh

# 4. Postmortem
$EDITOR INCIDENT.md && git add INCIDENT.md && git commit -m "docs: INC-311 postmortem"
```

Example `INCIDENT.md`:

```markdown
# INC-311: customers could not check out (Sev-1)

## Timeline
- 09:12 v3.1.0 deployed
- 09:40 ~200 support tickets: "can't check out"
- 09:55 incident declared; production rolled back to v3.0.0 (last good)
- 10:20 culprit identified with `git bisect run` (3 test runs)
- 10:45 v3.1.1 (revert) deployed; checkout verified

## Root cause
Commit a9be5f6 ("refactor(checkout): use MIN_ITEMS consistently") changed `-ge` to `-gt`, so carts with
exactly one item were rejected. It was labelled a refactor, reviewed as "no behaviour change", and no test
covered single-item carts.

## Resolution
Reverted on release/3.1 and released v3.1.1; revert cherry-picked to main.
Follow-ups: add the repro to CI (owner: Dev), require a test for every checkout change (owner: Maya).
```

**Why it works:** bisect is a binary search over history: with ~9 commits it needs ~3 tests, with 1,000 about
10. `git bisect run` automates the good/bad marking using the script's exit code (125 = skip, for commits that
can't be built). Reverting instead of hand-fixing during an incident is deliberate: a revert is the smallest,
best-understood change ("go back to what worked"), and its message records exactly what was undone.

**Real-world notes**
- **Mitigate first, debug second.** Ops rolled back to v3.0.0 *before* anyone bisected — always restore
  service first. Bisect, revert, patch-release happen while customers are already safe.
- **Revert, then re-land.** Dev can re-apply the refactor later (`git revert <revert-hash>` on main, fix it,
  add a test). Reverting is not a judgement on the author.
- **Blameless postmortems.** Name the commit, never the person. The useful question is *why the system let
  it through* (a "refactor" label lowered review attention; no test for 1-item carts), which yields fixes
  PMs can prioritise.
- **Forward-port every fix.** Exercise 092's lesson again: a fix only on the release branch comes back as a
  regression in the next minor. `git tag --contains <revert>` shows which releases are safe.
- **Bisect tips:** `git bisect skip` for unbuildable commits, `git bisect log > bisect.txt` to attach to the
  ticket, `git bisect start --first-parent` to bisect only PR merges on a busy `main`, and
  `git bisect terms --term-old=fast --term-new=slow` for performance regressions.
