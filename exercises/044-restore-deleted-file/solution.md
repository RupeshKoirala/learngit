# Solution

```bash
git log --diff-filter=D --oneline -- src/coupons.js
# 4b5c6d7 Remove legacy coupon and banner code
echo 4b5c6d7 > ../ANSWER

git show 4b5c6d7^:src/coupons.js                    # preview the last version
git restore --source=4b5c6d7^ -- src/coupons.js     # bring just that file back
git status                                          # untracked: src/coupons.js
git add src/coupons.js
git commit -m "Restore coupon codes for Black Friday (removed in 4b5c6d7)"
```

**Why it works:** Git stores every version of every file forever (as long as a commit references it). A
deleted file is simply absent from the trees of later commits, but present in every earlier one. The
deleting commit's parent (`4b5c6d7^`) holds the **last** version, so restoring from there gives you Lena's
case-insensitive code — not the original from "Add coupon codes". `--diff-filter=D` narrows thousands of
commits down to the one that deleted the file; `--` tells Git that `src/coupons.js` is a path even though
it no longer exists.

**Why not `git revert 4b5c6d7`?** That would also resurrect `src/legacy-banner.js`, which was deleted on
purpose in the same commit. Restoring a single path is surgical.

**Real-world notes**
- Don't know the exact path anymore? `git log --diff-filter=D --name-only --oneline` lists every deletion
  in history; add `-- '*coupon*'` to filter with a glob.
- `git log --follow -- src/coupons.js` follows a file across renames, useful to see its full story before
  you bring it back.
- Put the deleting commit's hash in your message: reviewers (and future you) can see why it disappeared and
  why it's back.
- Before resurrecting old code, check what changed around it. Here `cart.js` gained new functions — the
  restored module may need updates to fit today's code. Run the tests.
