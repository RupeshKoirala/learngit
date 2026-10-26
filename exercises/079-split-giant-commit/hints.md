You don't have to "cut" the big commit — you can **rebuild** the work from it. Any file can be copied out of any
commit into your working tree and index: `git checkout feature/checkout-revamp -- src/tax.js`
(same as `git restore --source feature/checkout-revamp --staged --worktree src/tax.js`).
---
Build the stack bottom-up: `git switch -c feature/tax main`, take the tax files from the big commit, commit.
Then `git switch -c feature/shipping` (it starts from where you are: `feature/tax`), take the shipping files, commit.
---
For the top of the stack you can take *everything*: `git switch -c feature/checkout-ui` then
`git checkout feature/checkout-revamp -- .` — the tax and shipping files are already identical, so only the
remaining changes get staged.
---
Verify each layer: `git diff --stat main feature/tax`, `git diff --stat feature/tax feature/shipping`,
`git diff --stat feature/shipping feature/checkout-ui`, and finally
`git diff feature/checkout-revamp feature/checkout-ui` must print nothing.
