# Solution

### 1–2. Who removed `applyCoupon`?

```bash
git log --oneline -S'function applyCoupon'
# 5d1450a Rename coupons to promo codes      <- newest: the removal
# 18faac7 Add coupon support                 <- oldest: the addition
git show 5d1450a -- src/discount.js
# -function applyCoupon(total, code) {
# +function redeemCode(total, code) {
git tag removed-applyCoupon 5d1450a
echo redeemCode > ../ANSWER
```

Jo's fix is to call `redeemCode` instead (or rebase onto `main` and let the conflict show where).

### 3. Who broke plus-addresses?

```bash
git log --oneline -S'EMAIL_RE' -- src         # only the commit that introduced it, so -S can't see edits
git log --oneline -G'EMAIL_RE'                # 5 commits, two of them only touch docs/api.md
git log -p -G'EMAIL_RE' -- src/validate.js    # 3 commits with diffs. Read them:
#   b27c3d1 Add signup form validation      + [a-z0-9._+-]+@   (introduced, + allowed)
#   2ea07b3 Accept upper-case letters      .../i flag added    (harmless)
#   5c1ccdf Tighten signup validation      - [a-z0-9._+-]  + [a-z0-9._-]   <- the culprit
git tag regex-change 5c1ccdf
```

**Why it works**
- **`-S<string>`** ("pickaxe") compares how many times the string appears before and after each commit,
  and lists the commit only if that count changed. It's perfect for "when was X added or removed", and
  ignores commits that merely edit lines near X.
- **`-G<regex>`** lists commits whose diff has an added or removed line matching the regex. It catches
  *edits* to a line, even when the number of occurrences stays the same.
- **`-- <path>`** limits the search to commits that touched those paths. The docs mention `EMAIL_RE`
  too, and the path filter removes that noise.
- Pickaxe options combine with everything else in `git log`: `--author`, `--since`, `-p`, `--all` (search every
  branch, which helps when the code only ever lived on a branch).

**Real-world notes**
- **"When did this get deleted?"** is the classic pickaxe question. Blame can't answer it because the line
  is gone. A related trick is `git log --diff-filter=D --name-only` to find commits that deleted whole *files*.
- `-S` takes a literal string by default. Add `--pickaxe-regex` to make it a regex. Use `-G` when the
  string's *count* doesn't change (edits, renames inside a line, regex tweaks).
- `git log -S` on a big repo can be slow, because it diffs every commit. Add a path (`-- src/`) and a range
  (`v2.0..main`) to speed it up.
- The *why* matters as much as the *what*. "Reject odd characters that spam bots use" was a reasonable
  intent with an unintended side effect. Fix forward with a test for `anna+shop@example.com`, and link
  the original commit in the PR so reviewers see the history.
- GitHub has no pickaxe in the UI. This is one of the places where the CLI is much more powerful than the web.
