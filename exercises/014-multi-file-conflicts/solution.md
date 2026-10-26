# Solution

```bash
git status                              # Jo's mess: cart.js staged as "theirs", price.js + legacy file unmerged
git merge --abort                       # back to main exactly as before the merge
git config merge.conflictStyle diff3    # (zdiff3 on git >= 2.35; add --global to keep it forever)
git merge release/1.4
# CONFLICT (content): Merge conflict in src/cart.js
# CONFLICT (modify/delete): src/legacy-coupons.js deleted in HEAD and modified in release/1.4.
# CONFLICT (content): Merge conflict in src/price.js
git status --short
# M  CHANGELOG.md            <- merged cleanly, already staged
# UU src/cart.js
# DU src/legacy-coupons.js   <- Deleted by Us, Updated by them
# UU src/price.js
git diff                                # combined diff: only what is still unresolved
```

**`src/cart.js`** — with diff3 you see three versions:

```
<<<<<<< HEAD
function lineTotal(item) {
  return item.price * item.qty;
||||||| 9e1c708
function total(cart) {
  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
=======
function total(cart) {
  return Math.round(cart.items.reduce((sum, i) => sum + i.price * i.qty, 0));
>>>>>>> release/1.4
}

function total(cart) {
  return cart.items.reduce((sum, i) => sum + lineTotal(i), 0);
}
```

The base shows the truth: main **added** `lineTotal` *above* `total` (whose new version is below the block);
the release **changed** `total`. Without the base you'd likely keep both blocks and end up with two `total`
functions. Correct result:

```js
function lineTotal(item) {
  return item.price * item.qty;
}

function total(cart) {
  return Math.round(cart.items.reduce((sum, i) => sum + lineTotal(i), 0));
}
```

**`src/price.js`** — combine the signature from main with the guard from the release, and fix the guard so a
refund in euros doesn't turn into dollars:

```js
function formatPrice(cents, currency = '$') {
  if (cents < 0) return '-' + formatPrice(-cents, currency);
  return currency + (cents / 100).toFixed(2);
}
```

**`src/legacy-coupons.js`** — modify/delete: the deletion was intentional, but the fix must survive. Port it:

```bash
git rm src/legacy-coupons.js
# edit src/discount.js:  if (coupon.expires <= now) return false;
git add src/cart.js src/price.js src/discount.js
git diff --cached --check               # no markers, no whitespace junk
./test.sh
git commit                              # "Merge branch 'release/1.4'"
```

**Why it works:** `merge --abort` restores the pre-merge state (it's `git reset --merge` under the hood), so
you start from a known-good place instead of auditing someone else's partial choices. diff3 adds the common
ancestor, turning "two different versions" into "two different *changes*", which is what you actually need to
combine. A modify/delete conflict is Git asking "one side deleted this, the other improved it — which wins?";
the answer can be "the deletion, but move the improvement somewhere else". A merge commit may contain edits to
files that weren't conflicted — that's legitimate when it's part of resolving the merge.

**Real-world notes**
- Put `git config --global merge.conflictStyle zdiff3` in every machine you own. Most seniors do.
- Jo's mistake is the classic one: `--theirs`/`--ours` on a *code* file throws away the other side's work
  silently. They're right for generated files (next exercise), almost never for source code.
- When you take over someone's broken operation, abort and redo. It's faster than reverse-engineering what they
  did, and `git merge --abort` can't lose committed work.
- Back-merging release branches into main is part of the release manager's job. Do it right after each hotfix
  release while the context is fresh — the longer you wait, the worse the conflicts.
- In a PR description for a merge like this, list the non-obvious resolutions ("ported coupon expiry fix to
  discount.js") so reviewers know where to look.
- `git checkout --conflict=diff3 <file>` (or `git restore --conflict=diff3 <file>`) re-creates the markers
  for one file if you botched its resolution — but only while it's still unmerged (before `git add`).
