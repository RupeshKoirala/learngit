# Solution

```bash
# 1. a fresh clone, from the sandbox folder
cd ..                                   # the sandbox
git clone remotes/origin.git fresh
git -C fresh remote -v                  # origin -> .../remotes/origin.git (fetch and push)
git -C fresh branch -a                  # * main, remotes/origin/HEAD -> origin/main, origin/main, origin/feature/gift-cards

# 2. look before you leap
cd repo
git fetch                               # updates origin/main, creates origin/feature/gift-cards
git status                              # "Your branch is behind 'origin/main' by 3 commits, and can be fast-forwarded."
git log --oneline main..origin/main     # the 3 commits you'd get
git diff main origin/main --stat        # which files they touch
git rev-list --count main..origin/main > ../ANSWER

# 3. update without surprises
git merge --ff-only origin/main         # or: git pull --ff-only

# 4. track Lena's branch
git switch feature/gift-cards           # "branch 'feature/gift-cards' set up to track 'origin/feature/gift-cards'"
git switch main
```

**Why it works:** a clone has two kinds of branches. **Local branches** (`main`) are yours and move only when you
commit, merge, reset… **Remote-tracking branches** (`origin/main`) are Git's memory of where the remote's
branches were *the last time you talked to it*. `git fetch` refreshes that memory and nothing else, so it is
always safe. `git pull` is `git fetch` **plus** an integrate step (merge or rebase) into your current branch —
convenient, but it decides for you. Splitting it into fetch → inspect → `merge --ff-only` means you see what's
coming and Git refuses rather than creating a surprise merge commit.

`git clone` sets all this up for you: remote `origin`, `origin/*` for every branch, `origin/HEAD` (the remote's
default branch), and one local branch, `main`, already tracking `origin/main`.

**Real-world notes**
- Make it the default: `git config --global pull.ff only`. Then a plain `git pull` either fast-forwards or stops
  and tells you the branches diverged — you then choose merge or rebase on purpose (exercise 067).
- `git fetch --all --prune` first thing in the morning (or `fetch.prune=true`) keeps `origin/*` honest; many
  IDEs auto-fetch in the background, which matters for `--force-with-lease` (exercise 063).
- `git log --oneline --graph main origin/main` (or `./lg graph`) is the fastest way to see "who is ahead".
- As a lead, encourage people to read `git log main..origin/main` after holidays: it's a 30-second changelog,
  and the moment to spot a migration or config change before it bites.
