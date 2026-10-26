# Solution

```bash
git rebase main
# CONFLICT (content): Merge conflict in src/cart.js
# error: could not apply 1a2b3c4... Fix total() crashing on a cart without items
git diff                       # main's guard vs yours
git rebase --skip              # main already has this fix: drop my commit

# CONFLICT (content): Merge conflict in src/price.js
# error: could not apply 5d6e7f8... Support a currency symbol in formatPrice
$EDITOR src/price.js           # combine both sides, remove the markers
git add src/price.js
git rebase --continue          # keeps the original message

git log --oneline main..       # 2 commits
./test.sh
```

The resolved file:

```js
// Price formatting
function formatPrice(cents, symbol = '$') {
  const sign = cents < 0 ? '-' : '';
  return sign + symbol + (Math.abs(cents) / 100).toFixed(2);
}
```

**Why it works:** a rebase replays your commits one by one, so you resolve conflicts *one commit at a time*.
Each stop gives you three choices:

| Command | Meaning |
|---|---|
| `git rebase --continue` | "I've resolved this commit (and `git add`ed it) — commit it and go on." |
| `git rebase --skip` | "Drop this commit entirely and go on." Right when the change is already upstream. |
| `git rebase --abort` | "Forget the whole rebase" — branch, index and working tree go back to how they were. |

Note the side swap: in a rebase, `HEAD`/"ours" is the new base (main + already-replayed commits) and "theirs" is
the commit being replayed. So `git checkout --theirs file` means *your* version here — the opposite of a merge.

Git skips commits that are **identical** to something upstream on its own (it compares patch IDs and prints
"skipped previously applied commit"). Maya's fix did the same job with different code, so Git couldn't know —
recognising "this is already done" is your call, and `--skip` is the tool.

**Real-world notes**
- When you skip, make sure upstream really covers your change — read both sides. Here main's version is a
  superset of yours; if yours had handled an extra case, you'd resolve by keeping that extra case instead.
- Resolve conflicts so that *that commit* makes sense on its own, not just so the final result works. A
  reviewer (or `git bisect`) will look at commits individually.
- Turn on `git config --global rerere.enabled true`: Git records how you resolved a conflict and replays the
  resolution next time the same conflict appears (common when you rebase a long branch repeatedly).
- `git config --global merge.conflictStyle zdiff3` shows the common ancestor inside the markers — it makes it
  much easier to see what each side actually changed.
- Rather than a long-lived branch that conflicts on every rebase, rebase often (daily) and keep PRs small.
