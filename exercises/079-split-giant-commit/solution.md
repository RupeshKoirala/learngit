# Solution

```bash
cd repo
git show --stat feature/checkout-revamp            # what's in the monster
BIG=feature/checkout-revamp

git switch -c feature/tax main
git checkout $BIG -- src/tax.js src/tax-rates.js   # copy files out of the big commit (staged)
git commit -m "Add sales tax by region"

git switch -c feature/shipping                     # starts at feature/tax
git checkout $BIG -- src/shipping.js src/shipping-zones.js
git commit -m "Add shipping cost by postcode zone"

git switch -c feature/checkout-ui                  # starts at feature/shipping
git checkout $BIG -- .                             # everything else: only UI, cart.js, README differ now
git commit -m "Add checkout summary UI"

git diff $BIG feature/checkout-ui                  # empty: nothing lost
git log --oneline --graph main..feature/checkout-ui
```

**Why it works:** a commit is a snapshot, so you never need to surgically "split" it: you can *rebuild* the same
end state in smaller steps. `git checkout <commit> -- <paths>` copies those paths from any commit into your index
and working tree. Branching each layer off the previous one makes them **stacked**: each PR contains exactly one
layer when its base is the branch below. Comparing the top of the stack with the original proves nothing was lost.

When a split isn't along file boundaries, use the other classic: `git switch feature/checkout-revamp`,
`git reset HEAD~` (un-commit, keep changes), then `git add -p` to stage hunk by hunk and commit in pieces.

**Real-world notes**
- **Opening stacked PRs on GitHub:** push all three, then open PR 1 `feature/tax → main`, PR 2
  `feature/shipping → feature/tax`, PR 3 `feature/checkout-ui → feature/shipping`. Each shows only its layer.
  When PR 1 merges, GitHub retargets PR 2 to `main` automatically (if the base branch is deleted on merge).
- **Keeping a stack up to date:** after fixing review comments on `feature/tax`, rebase the whole stack in one go
  with `git switch feature/checkout-ui && git rebase --update-refs feature/tax` (Git ≥ 2.38; set
  `rebase.updateRefs=true`). With squash-merges, use `git rebase --onto main <old-tax-tip> feature/shipping`.
- Each layer should build and pass tests on its own — reviewers and `git bisect` both rely on that. Here tax and
  shipping don't depend on the UI, so the order works.
- Generated data (the rate tables) inflates line counts; mention it in the PR description or mark the files with
  `linguist-generated=true` in `.gitattributes` so GitHub collapses them in diffs.
- Prevent it: commit in small steps as you go and push early — a draft PR on day 1 beats a 1,500-line surprise on day 5.
