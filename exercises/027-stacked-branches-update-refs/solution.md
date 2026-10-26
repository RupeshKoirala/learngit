# Solution

```bash
git switch feature/checkout-3-ui
git rebase --update-refs main
# Successfully rebased and updated refs/heads/feature/checkout-3-ui.
# Updated the following refs with --update-refs:
#     refs/heads/feature/checkout-1-model
#     refs/heads/feature/checkout-2-api

git log --oneline --graph main~1..feature/checkout-3-ui
```

```
* Show order confirmation       <- feature/checkout-3-ui
* Add checkout page
* Add POST /orders endpoint     <- feature/checkout-2-api
* Validate order addresses      <- feature/checkout-1-model
* Add Order model
* Add removeItem to cart        <- main
```

With `-i` you can see the mechanism — Git inserts an `update-ref` line wherever a branch pointed:

```
pick 1111111 Add Order model
pick 2222222 Validate order addresses
update-ref refs/heads/feature/checkout-1-model

pick 3333333 Add POST /orders endpoint
update-ref refs/heads/feature/checkout-2-api

pick 4444444 Add checkout page
pick 5555555 Show order confirmation
```

**Why it works:** a rebase rewrites commits, and only the branch being rebased is moved to the new copies.
Branches that pointed *into* the middle of the stack would keep pointing at the old commits — the stack would
silently "fork". `--update-refs` notes which local branches point at commits in the rewritten range and moves
each to the rewritten copy at the end. One rebase, one set of conflicts, all pointers correct.

**The manual way (Git < 2.38, or to understand it):** rebase bottom-up, and for each layer cut the range at the
*old* tip of the layer below:

```bash
old1=$(git rev-parse feature/checkout-1-model)
old2=$(git rev-parse feature/checkout-2-api)
git rebase main feature/checkout-1-model
git rebase --onto feature/checkout-1-model $old1 feature/checkout-2-api
git rebase --onto feature/checkout-2-api   $old2 feature/checkout-3-ui
```

**Real-world notes**
- `git config --global rebase.updateRefs true` makes this the default — recommended if you stack branches.
- Pushing a rebased stack: `git push --force-with-lease origin feature/checkout-1-model feature/checkout-2-api
  feature/checkout-3-ui` (or `git push --force-with-lease --atomic …` so all-or-nothing).
- On GitHub, PR #2's base is `feature/checkout-1-model`, PR #3's base is `feature/checkout-2-api`, so each PR
  shows only its own diff. Merge bottom-up; when #1 merges (if squashed!) you're back to exercise 026's
  `--onto` situation for the rest of the stack — which is why some teams use dedicated stacking tools
  (Graphite, ghstack, git-branchless, spr).
- Stacked PRs are a lead's tool for keeping review fast: small diffs get reviewed in hours, big ones in days.
  Keep each layer independently green in CI.
