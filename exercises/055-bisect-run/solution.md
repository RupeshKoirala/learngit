# Solution

First, see the trap:

```bash
git bisect start main v2.0
git bisect run sh test/run.sh
# 5ed014b is the first bad commit
#     WIP: move price formatter to lib/ (build broken)      <- wrong! bin/price simply doesn't exist here
git bisect reset
```

Now with a script that knows "untestable" isn't the same as "bad":

```sh
#!/bin/sh
# ../bisect-test.sh   (outside the repo, so checkouts can't touch it)
[ -f bin/price ] || exit 125      # can't test this commit -> skip
exec sh test/run.sh               # 0 = good, 1 = bad
```

```bash
chmod +x ../bisect-test.sh
git bisect start main v2.0
git bisect run ../bisect-test.sh
# ... 8 steps, a couple of them skipped ...
# de8e5d3 is the first bad commit
#     Simplify cents formatting
git show de8e5d3           # c % 100  ->  c % 10   (only keeps the last digit of the cents)
git bisect log | grep skip # see which commits were skipped
git tag first-bad de8e5d3
git bisect reset
```

**Why it works:** `bisect run` turns your script's exit code into an answer: `0` = good, `1`–`127` = bad,
**`125` = skip**, and anything else (e.g. 128+, a crash) stops the bisect. When a commit is skipped, Git
picks a nearby commit instead and carries on. It can only fail to decide if the skipped commits sit right at
the boundary. Then it lists the possible culprits, and you skip less or judge one by hand.

**Real-world notes**
- **Keep the script outside the repo** (or make sure it's untracked and ignored), because bisect checks out
  old commits that might not have it. Same for test *fixtures*: if the test only exists on `main`, copy it
  to `/tmp` first and run that copy, so every old commit gets the *same* test.
- **Make "can't build" a skip, never a fail.** Typical skip conditions: compile error, missing dependency,
  a migration that can't run. Ask yourself "is this the bug I'm hunting?" If not, exit 125.
- Bisect run can't judge "it's slow" or "it looks wrong" unless you turn that into an exit code, e.g.
  `timeout 5 ./bench || exit 1`, or a `grep` on the output.
- Commits that are untestable in the middle of `main` are a smell. Squash-merging WIP branches, or
  requiring CI to pass on every commit, keeps `main` bisectable. Teams that bisect a lot treat
  *"every commit builds"* as a rule.
- `git bisect start --first-parent` (git ≥ 2.29) bisects only through merge commits on `main`, which helps
  when feature branches are full of WIP. It finds *the PR*, then you bisect inside it.
- After you find it: write the failing test first (`check 1999 '$19.99'` already is one), fix forward, and
  mention the culprit in the fix message ("Fixes de8e5d3").
