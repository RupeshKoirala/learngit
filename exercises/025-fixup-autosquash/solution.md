# Solution

```bash
git log --oneline main..
# 3333333 Document gift cards
# 2222222 Redeem gift cards at checkout
# 1111111 Add gift card model

git add src/giftcard.js
git commit --fixup 1111111            # -> "fixup! Add gift card model"
git add src/checkout.js
git commit --fixup 2222222            # -> "fixup! Redeem gift cards at checkout"

git rebase -i --autosquash main
```

The todo list arrives pre-arranged — just save:

```
pick   1111111 Add gift card model
fixup  4444444 fixup! Add gift card model
pick   2222222 Redeem gift cards at checkout
fixup  5555555 fixup! Redeem gift cards at checkout
pick   3333333 Document gift cards
```

```bash
git config rebase.autoSquash true     # or --global
git log --stat --oneline main..       # 3 commits, original messages
git diff ORIG_HEAD HEAD               # empty: same final code
```

**Why it works:** `--fixup <commit>` records "this belongs in that commit" in the message itself
(`fixup! <original subject>`). With `--autosquash`, the rebase todo list moves every `fixup!` commit directly
below the commit whose subject matches and changes its command to `fixup`, so it melts into its target and its
own message is discarded. `rebase.autoSquash = true` makes every `git rebase -i` do this without the flag (`--no-autosquash` turns it
off for one run). Since Git 2.44 the `--autosquash` flag also works without `-i`; the config setting still only
affects interactive rebases.

**Variants worth knowing**
- `git commit --squash <commit>` → `squash!`: like fixup but lets you edit the combined message.
- `git commit --fixup=amend:<commit>` → `amend!`: replaces the target's *message* too (fixing a typo in an old
  commit message, plus or minus code).
- `git commit --fixup=reword:<commit>`: change only the message of an older commit, no code.
- `git rebase -i --autosquash $(git merge-base HEAD main)` fixes up without moving onto a newer main.

**Real-world notes**
- This is the best of both worlds for code review: during review, **push the fixup commits** so reviewers can
  see exactly what changed since their last look ("Changes since last review" on GitHub works on commits).
  Squash them right before merging, then `git push --force-with-lease`.
- Some teams skip the dance and use GitHub's "Squash and merge"; fixups matter when the team keeps multi-commit
  PRs (rebase-merge), which gives better `blame`, `bisect` and `revert` granularity.
- Tools like `git absorb` find the right target commit for each staged hunk automatically and create the fixups
  for you.
- Never autosquash into commits that are already on `main` — those are shared history.
