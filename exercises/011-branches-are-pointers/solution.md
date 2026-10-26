# Solution

```bash
git log --oneline --graph --all --decorate     # see every name first

git branch hotfix/1.0.1 v1.0                   # from a tag
git log --oneline main                         # find 'Add free-shipping threshold', e.g. 3c4d5e6
git branch experiment/shipping-rules 3c4d5e6   # from an older commit (main~2 works too)
git branch -m fixtypo fix/readme-typo          # rename
git switch -c feature/wishlist main            # create from main's tip and switch

git branch -vv
#   experiment/shipping-rules 3c4d5e6 Add free-shipping threshold
# * feature/wishlist          9f8e7d6 Add product search box
#   fix/readme-typo           1a2b3c4 Fix typo in README
#   hotfix/1.0.1              5e6f7a8 Add removeItem to cart
#   main                      9f8e7d6 [origin/main] Add product search box
#   release/1.0               5e6f7a8 [origin/release/1.0: behind 1] Add removeItem to cart
echo release/1.0 > ../ANSWER
```

**Why it works:** a branch is a file containing one commit hash (look: `cat .git/refs/heads/main`, or
`git rev-parse main`). `git branch X <start>` just writes a new file; nothing in your working tree changes.
A tag is the same idea except it never moves. `git switch` is the only step that changes your files: it
points `HEAD` at a different branch and updates the working tree to match. `-vv` adds the upstream and
the ahead/behind count, computed from your **last fetch** — it doesn't talk to the server.

**Real-world notes**
- Branch from a tag for hotfixes: `hotfix/1.0.1` starts from exactly what customers run, not from `main`
  with three weeks of unreleased work on top.
- Use prefixes your team agrees on (`feature/`, `fix/`, `hotfix/`, `chore/`, `experiment/`). Many CI
  rules and branch protections match on them, and they group nicely in UIs.
- Renaming a branch you already pushed is two steps: `git push origin -u fix/readme-typo` then
  `git push origin --delete fixtypo`. Open PRs on GitHub follow a rename done in the GitHub UI, but not a
  delete+push from the command line — rename on GitHub if a PR is open.
- `behind 1` is only as fresh as your last `git fetch`. Before trusting it, fetch. `git branch -vv` is a
  great Monday-morning command to see what's stale.
