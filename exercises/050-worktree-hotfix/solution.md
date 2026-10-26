# Solution

```bash
# in repo/ — leave everything as it is
git worktree add -b hotfix/empty-cart-crash ../hotfix main
cd ../hotfix
git status                     # clean checkout of main's code on the new branch
```

Edit `src/checkout.js`:

```js
// Checkout
function shippingFor(cart) {
  if (cart.items.length === 0) return 0;
  return cart.items[0].weight > 5000 ? 900 : 499;
}
```

```bash
./test.sh                                        # tests passed
git commit -am "Fix checkout crash on empty cart"
git switch main                                  # allowed: main isn't checked out in any other worktree
git merge --ff-only hotfix/empty-cart-crash
cd ../repo
git worktree remove ../hotfix
git worktree list                                # just repo
git status                                       # staged README, modified reviews.js, untracked reviews-ui.js
```

**Why it works:** a repository can have many **working trees**. They share one object database, one set of
branches and one config, but each has its own `HEAD`, index and files. So the hotfix had its own clean
checkout while your staged/unstaged/untracked feature work sat untouched in `repo/`. The commit you made in
`../hotfix` instantly exists in `repo` too — same repository. Git forbids checking out the same branch in
two worktrees, which prevents the two directories fighting over one branch.

Updating `main` without checking it out anywhere also works from `repo/`:
`git fetch . hotfix/empty-cart-crash:main` (fast-forward only — it refuses anything else).

**Real-world notes**
- Stash vs worktree: stash is great for a 2-minute interruption. A worktree wins when the interruption is
  long, when your work includes a delicate staged/unstaged split (stash can mangle it on pop), or when you
  want to keep a dev server / build running in one folder while you work in another.
- Worktrees are handy for reviewing PRs too: `git worktree add ../review-123 origin/pr-branch`, run it,
  delete it. No stashing, no rebuilding `node_modules` in your main checkout... though each worktree needs
  its own dependencies installed.
- In a real team the hotfix goes through a PR with CI, then gets deployed, and `feature/reviews` later
  rebases on (or merges) `main` to pick up the fix.
- Clean up: forgotten worktrees keep their branch "checked out", which blocks `git switch` to that branch
  elsewhere. `git worktree list` regularly, `git worktree prune` after deleting folders by hand.
