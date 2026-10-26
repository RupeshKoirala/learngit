Rebase from the **top** of the stack: `git switch feature/checkout-3-ui`. A normal `git rebase main` would move
all five commits — but only the branch you're on would follow them. Look at `./lg graph` afterwards if you try
it (and `git reset --hard ORIG_HEAD` to undo).
---
`git rebase --update-refs main` does the same rebase *and* moves every other local branch that points at one
of the commits being rewritten. Try `git rebase -i --update-refs main` once to see the `update-ref
refs/heads/...` lines it adds to the todo list.
---
`git switch feature/checkout-3-ui && git rebase --update-refs main`. Then check each layer:
`git log --oneline main..feature/checkout-1-model`, `feature/checkout-1-model..feature/checkout-2-api`, …
---
Git older than 2.38? Do it bottom-up with `--onto`, remembering each old tip first:
`old1=$(git rev-parse feature/checkout-1-model)`, `old2=$(git rev-parse feature/checkout-2-api)`, then
`git rebase main feature/checkout-1-model`, `git rebase --onto feature/checkout-1-model $old1 feature/checkout-2-api`,
`git rebase --onto feature/checkout-2-api $old2 feature/checkout-3-ui`.
