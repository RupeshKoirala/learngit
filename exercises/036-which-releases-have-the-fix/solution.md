# Solution

**Question 1 — which 2.x release has the CA tax fix?**

```bash
fix=$(git log --format=%h --grep='^fix: round CA' main)
git tag --contains $fix                  # v3.0.0   <- misleading for a 2.x customer
git branch --contains $fix               # main     <- same blind spot

git log --oneline --cherry-mark --left-right release/2.x...main
# > ef194fe feat: wishlist
# > c08fec4 Release 3.0.0
# > 712da6a chore: bump test runner
# > 5a4551f fix: cart badge count off by one
# = b67cc28 Round tax correctly (backport for 2.x customers)
# = 81d914c fix: retry payment on gateway timeout
# = a9fac5e fix: round CA sales tax to the nearest cent
# > c791658 feat: dark mode
# = 1798c7a fix: retry payment on gateway timeout
# > 5c632e3 feat: gift cards
#   (= means "has an equivalent on the other side"; it replaces the < / > marker)

git log --oneline --cherry-mark --left-only release/2.x...main     # just the release side
# = b67cc28 Round tax correctly (backport for 2.x customers)   <- the copy, renamed
# = 81d914c fix: retry payment on gateway timeout

git tag --contains b67cc28               # v2.0.2
echo v2.0.2 > ../ANSWER
```

**Question 2 — which fixes never got backported?**

```bash
git cherry -v release/2.x main
# + 1111111 feat: gift cards
# - 2222222 fix: retry payment on gateway timeout        (equivalent already on 2.x)
# + 3333333 feat: dark mode
# - 4444444 fix: round CA sales tax to the nearest cent  (equivalent already on 2.x)
# + 5555555 fix: cart badge count off by one             <- the gap
# + ...     chore / release / feat

git switch release/2.x
git cherry-pick -x 5555555
git tag -a v2.0.3 -m "2.0.3: cart badge fix"
git cherry -v release/2.x main | grep fix:       # all '-' now
```

**Why it works:** `--contains` answers "is this *commit object* in the history of that ref?". Cherry-picks
are new objects, so `--contains` is blind to them. `git cherry`, `--cherry-pick`, and `--cherry-mark`
compute a **patch-id** for each commit — a hash of the diff with line numbers and whitespace stripped —
and match commits whose diffs are identical, whatever their hash or message. That's how the renamed tax
backport was found even without an `-x` line.

The tools, side by side:

| Question | Command |
|---|---|
| Is this exact commit on branch/tag X? | `git branch -a --contains H`, `git tag --contains H`, `git merge-base --is-ancestor H X` |
| Which of B's commits are missing from A, by content? | `git cherry -v A B` (`+` missing, `-` already there) |
| Two-sided view with equivalents marked `=` | `git log --oneline --cherry-mark --left-right A...B` (add `--left-only` for A's side) |
| Only the truly unique commits | `git log --oneline --cherry-pick --right-only A...B` |
| Find backports of H by their trailer | `git log --all --oneline --grep "cherry picked from commit H"` |

**Real-world notes**
- Patch-id matching breaks when a backport needed **conflict resolution** (the diff differs) — e.g. the 1.3
  backport in exercise 034. That's why `-x` matters: the trailer survives where patch-ids don't. The
  renamed, trailer-less tax backport here is what *not* to do — it was only findable because it happened to
  apply cleanly.
- Turn this into a release checklist step or a CI job: before tagging a 2.x release, run
  `git log --cherry-pick --right-only --oneline --grep '^fix:' release/2.x...main` and review every line.
  Not every fix *should* be backported (some fix 3.x-only code), but every omission should be a decision.
- Answering "which version has the fix?" is a daily support/PM question. Many teams automate it: a bot
  comments on the original PR "backported to 2.x in v2.0.3". Conventional-commit prefixes (`fix:`, `feat:`)
  make these queries easy.
