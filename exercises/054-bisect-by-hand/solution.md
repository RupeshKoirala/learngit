# Solution

```bash
git bisect start main v1.4          # bad first, then good
# Bisecting: 14 revisions left to test after this (roughly 4 steps)
# [aa44bce] Tagline A/B test: cozy picks
cat ui/checkout.txt                 # button inside the card
git bisect good
# [d1479ca] Remove !important overrides
cat ui/checkout.txt                 # button hanging off the right edge
git bisect bad
# [eea4746] Align prices to the right
git bisect good
# [4abd8b1] Dark mode for checkout
git bisect bad
# [a1265d4] Tighten checkout layout spacing
git bisect bad
# a1265d4... is the first bad commit
git show a1265d4 -- src/layout.css  # .place-order { margin-left: calc(100% + 8px); }  <- there it is
git tag first-bad a1265d4
git bisect reset                    # back to main, bisect refs cleaned up
```

Five checks out of 30 commits. The decoy, "Fix Place order button alignment", was innocent. Reading commit
messages would have sent you the wrong way.

**Why it works:** bisect is a binary search over the commit graph. Every answer removes about half of the
remaining suspects, so N commits need only about log₂ N checks: 30 commits take ~5, 1,000 take ~10. It
relies on one assumption: once broken, it stays broken until fixed (the bug is *monotonic* across the
range).

**Real-world notes**
- **Write down the good/bad rule before you start**, e.g. "bad = button outside the card", and judge only that.
  Unrelated changes (a new tagline, a different price) are noise. If something *else* is broken and you
  can't judge, use `git bisect skip`.
- **Wrong answer?** You don't have to start over. `git bisect log > fix.log`, edit out the wrong line, then
  `git bisect reset` and `git bisect replay fix.log`.
- **Any terms you like:** if "good/bad" confuses you (e.g. you're looking for when something got *fixed*), use
  `git bisect start --term-old=broken --term-new=fixed`.
- **On a real UI** each step means rebuilding and reloading the app. That's why bisecting by hand costs
  minutes per step, and why the next exercise automates it with `git bisect run`.
- **Bisect across merges** works too. If a long feature branch makes the search wander, `git bisect start
  --first-parent` (git ≥ 2.29) only steps through merges on `main`, so you find *which PR* broke it first.
- When you report the culprit, link the commit and its PR, and say what the rule was ("button outside the
  card since a1265d4"). People can then verify your call instead of trusting it.
