# Solution

```bash
git log --stat --oneline main..     # what each commit touches
git rebase -i main
```

Change the todo list (oldest first) to:

```
reword 1111111 asdf
reword 4444444 add btn
pick   2222222 Document the wishlist
drop   3333333 temp debug
```

Save and close. Git stops twice for the rewords: type `Add wishlist module`, then
`Add wishlist button to product page`.

```bash
git log --stat --oneline main..     # 3 clean commits
git log --oneline main.. -- src/debug.js   # nothing
git diff ORIG_HEAD HEAD --stat      # only src/debug.js removed
```

**Why it works:** the todo list *is* the new history. Git resets the branch to `main` and executes the lines
top to bottom: `pick` replays a commit as is, `reword` replays it and opens the message, `drop` (or a deleted
line) skips it. Reordering is just moving lines. These three commits touch different files, so moving
`Document the wishlist` after the code can't conflict. Dropping the debug commit removes `src/debug.js` from
the branch's history entirely, not just from the final tree — which is what you want for anything that should
never have existed (a `git rm` in a new commit would leave it readable in the PR history).

**Real-world notes**
- Commit subject conventions: imperative mood ("Add", not "Added"/"adds"), ≤ ~50 chars, a body explaining
  *why* when it isn't obvious. Many teams use Conventional Commits (`feat(wishlist): add heart button`) so tools
  can generate changelogs and version bumps — check your team's style before you push.
- Reordering is safe when commits touch different code. When they don't, moving a commit above the one it
  depends on causes conflicts — then resolve, or reconsider the order.
- If a secret or customer data had been **pushed**, dropping the commit is not enough: rotate the secret, and
  know that the remote (and every clone, and GitHub's PR refs) may still have it.
- Prevent the "temp debug" commit in the first place: `git add -p` to stage only what you mean, a pre-commit
  hook or lint rule that blocks `console.log`, and a global gitignore for scratch files.
- Rewriting your own unpushed (or unreviewed) branch is good manners. Once reviewers have commented on specific
  commits, prefer adding fixup commits (exercise 025) so their review context isn't lost.
