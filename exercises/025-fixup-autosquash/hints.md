`git log --oneline main..` gives you the hashes. `git add src/giftcard.js` then
`git commit --fixup <hash-of-"Add gift card model">` creates a commit called `fixup! Add gift card model`.
Do the same for `src/checkout.js` with the checkout commit.
---
You can also refer to a commit by message instead of hash: `git commit --fixup ':/Add gift card model'`
(the newest commit whose message matches).
---
Now `git rebase -i --autosquash main`. Look at the todo list before saving: Git has already moved each
`fixup!` commit right under its target and marked it `fixup`. Just save and close.
---
Last part: `git config rebase.autoSquash true` (inside the repo). From now on every `git rebase -i` arranges
fixup! commits for you. Check: `git log --oneline main..` shows 3 commits with the original messages.
