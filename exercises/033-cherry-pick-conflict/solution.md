# Solution

```bash
git switch main
git log --oneline main..release/3.1
git cherry-pick main..release/3.1        # oldest first: qty fix, version bump, price fix
```

**Stop 1 — the qty fix conflicts** in `src/cart.js`:

```
<<<<<<< HEAD
function lineTotal(item) {
  return item.price * item.qty;
=======
function total(cart) {
  return cart.items.reduce((sum, i) => sum + i.price * (i.qty || 1), 0);
>>>>>>> 1a2b3c4 (Fix total() for items without a qty)
}

function total(cart) {
  return cart.items.map(lineTotal).reduce((a, b) => a + b, 0);
}
```

Read it carefully: Git lined up the *old* `total()` against the *new* `lineTotal()` because they sit at the
same position. Blindly keeping "both sides" gives you broken code: a `lineTotal()` with the old formula *and* two
`total()` functions (in JavaScript the later one silently wins, so the fix would never run).

Neither side is right on its own. Keep `main`'s structure and re-apply the fix's *idea* where the logic now
lives:

```js
function lineTotal(item) {
  return item.price * (item.qty || 1);
}

function total(cart) {
  return cart.items.map(lineTotal).reduce((a, b) => a + b, 0);
}
```

```bash
git add src/cart.js
git cherry-pick --continue      # keeps the original message and author
```

**Stop 2 — `Release 3.1.1` conflicts** on `VERSION`. It's a release-only commit: `git cherry-pick --skip`.

The price fix applies cleanly and the sequence finishes. Verify:

```bash
git log --oneline -3
./test.sh
git diff release/3.1 main -- src/price.js    # empty: identical fix
```

(Picking just the two fixes — `git cherry-pick <qty-fix> <price-fix>` — avoids stop 2 entirely; also correct.)

**Why it works:** cherry-pick is a three-way merge: base = the fix's parent, "theirs" = the fix, "ours" =
`HEAD`. Both sides changed the same lines (the refactor and the fix), so Git can't decide and asks you.
`--continue` commits your resolution with the original message; `--skip` throws away the *current* commit
and moves on to the next in the sequence; `--abort` restores the branch to how it was before the whole
command.

**Real-world notes**
- **Resolve by intent, not by side.** "Take theirs" here would have silently reverted Lena's refactor;
  "take ours" would have dropped the fix. Reading `git show <fix>` before resolving is the habit that
  separates seniors from button-pushers.
- `git config --global merge.conflictStyle zdiff3` adds the **base** version to the markers
  (`||||||| base`), which makes "what did each side change?" obvious. Highly recommended.
- After a manual conflict resolution, the copy is no longer patch-identical to the original, so
  `git cherry` will report it as missing. Use `-x` on forward/backports so the link stays visible.
- Many teams prefer **fix on `main` first, then backport** to releases — it avoids exactly this "forgot to
  forward-port" risk. When the fire is in production and you hotfix the release branch first, put the
  forward-port on the incident checklist.
- Enable `git config --global rerere.enabled true`: Git remembers how you resolved a conflict and replays
  it the next time the same conflict appears (great when you backport the same fix to several branches).
