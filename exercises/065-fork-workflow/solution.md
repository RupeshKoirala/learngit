# Solution

```bash
# 1. a second remote for the source of truth
git remote add upstream ../remotes/brightcart.git
git fetch upstream
git remote -v

# 2. sync your fork's main (a pure mirror of upstream)
git switch main
git merge --ff-only upstream/main
git push origin main

# 3. update the PR
git switch feature/size-guide
git rebase upstream/main
./test.sh
git push --force-with-lease          # goes to origin = your fork
```

**Why it works:** a fork is just another remote repository; Git doesn't know or care that GitHub links it to the
original. Your clone talks to both: `origin` (read/write, your fork) and `upstream` (read-only for you).
`upstream/main` is the truth, so you fast-forward your `main` to it and mirror it to your fork. The PR branch is
rebased on that truth, which rewrites its two commits, so updating the fork's copy needs a (leased) force-push —
fine, because only you work on it. The PR on GitHub tracks the *branch*, so it updates by itself.

**Real-world notes**
- **Never commit on your fork's `main`.** Keep it a mirror and branch every PR from `upstream/main`
  (`git switch -c fix/x upstream/main`); then syncing is always a fast-forward.
- Make "push to upstream" impossible even if you have rights: `git remote set-url --push upstream DISABLED`.
  Fetching still works; pushing fails loudly.
- Shortcut once main isn't needed locally: skip step 2 and run `git rebase upstream/main` directly — your PR only
  cares about upstream. Many maintainers' docs, and `gh repo sync`, cover the fork's main for you.
- Inside a company you usually don't fork — everyone pushes branches to one repo. Forks shine for open source and
  for contractors/vendors who shouldn't get write access (a PM-relevant access-control decision).
- If the maintainer says "rebase", they want linear history; if the project uses merge commits, a
  `git merge upstream/main` into your branch is also acceptable — ask, or read CONTRIBUTING.md.
