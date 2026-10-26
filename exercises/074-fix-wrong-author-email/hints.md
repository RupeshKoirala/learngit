`--reset-author` takes the identity from your **config**, so fix the config first:
`git config user.email you@brightcart.example` (no `--global`: only this repo). Check with `git config user.email`.
---
You want to amend every commit in `origin/main..HEAD`. `git rebase` can run a command after each commit it
replays: `git rebase -x '<command>' origin/main`.
---
```bash
git rebase -x 'git commit --amend --no-edit --reset-author' origin/main
git log --format='%h %ae %ce %s' origin/main..HEAD
```
---
`.mailmap` lines look like `Proper Name <proper@email> <commit@email>`. Write one, then test it with
`git check-mailmap "Anyone <night.owl.coder@mail.example>"` and `git shortlog -sne`. Commit it.
