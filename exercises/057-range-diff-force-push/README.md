# git range-diff: what changed when the PR was force-pushed?

Yesterday you reviewed Lena's PR `feature/wishlist` (v1, 4 commits) and left comments. This morning
GitHub says *"lena force-pushed the feature/wishlist branch"*. She rebased onto the latest `main` and
"addressed feedback". Every commit hash is different now, so `git diff` between old and new tips is full of
unrelated changes from `main`.

You don't want to re-review everything. You want to know **exactly what she changed in her own
commits**. That's what `git range-diff` is for: it pairs up the old and new versions of each commit and
diffs the *diffs*.

```
v1 (what you reviewed)                  v2 (just force-pushed)
* Add debug logging for wishlist        * Cap wishlist size
* Cap wishlist size                     * Add GET/POST /api/wishlist endpoint
* Add wishlist API endpoint             * Add wishlist model
* Add wishlist model                    * Add product search          (new on main)
* Add product pages  (old main)         * Note product image TODO     (new on main)
                                        * Add product pages
```

You haven't fetched since your review, so your clone still has v1 as `origin/feature/wishlist`.

## Your task

In `repo`:

1. Fetch, so `origin/feature/wishlist` is v2. (Your remote-tracking ref's reflog keeps the old v1 tip for
   you: `origin/feature/wishlist@{1}`.)
2. Compare v1 and v2 with `git range-diff`. One commit's **code** changed and another only got a new
   **message**. Tag the **v2 commit whose code changed** as **`changed-commit`**.
3. Write into `../ANSWER` (one `key=value` per line):
   ```
   cap=<the new value of MAX_ITEMS in v2>
   dropped=<the v1 hash (short is fine) of the commit that is gone in v2>
   ```

Don't create, move or delete any branches.

## You'll practice

`git fetch` and reading `(forced update)`, the reflog of remote-tracking refs (`@{1}`), all three forms of
`git range-diff`, and reading its `=`, `!`, `<`, `>` markers.
