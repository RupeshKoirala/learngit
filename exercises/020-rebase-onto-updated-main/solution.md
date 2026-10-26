# Solution

```bash
git log --oneline --graph --all            # see where everything is

# 1. The merge way, on a throwaway branch
git branch compare/merge                   # new branch at the current feature tip (you stay put)
git switch compare/merge
git merge main                             # creates "Merge branch 'main' into compare/merge"

# 2. The rebase way, on the real branch
git switch feature/free-shipping
git rebase main

git log --oneline --graph --all
git diff compare/merge feature/free-shipping      # empty: same files, different history
git range-diff main ORIG_HEAD HEAD                # old vs new version of each of your commits
```

Afterwards the graph looks like this:

```
*   2061af6 Merge branch 'main' into compare/merge      <- compare/merge
|\
* | 10fb634 Free shipping on orders over $50        (your ORIGINAL commits)
* | 2a1c476 Add flat-rate shipping cost
| | * 594ef87 Free shipping on orders over $50      <- feature/free-shipping (new hashes!)
| | * a2b2f68 Add flat-rate shipping cost
| |/
| * 5158d30 Format prices with thousands separators <- main
| * c2161e7 Add removeItem to cart
|/
* 0b5999b Initial storefront
```

**Why it works:** `git rebase main` finds the commits that are on your branch but not on `main`
(`main..feature/free-shipping`), sets them aside, moves your branch to `main`, and re-applies them one at a time,
like a series of cherry-picks. Each re-applied commit has a new parent, so it gets a **new hash** even though
the change, message, author and author date are the same. That's the whole price of a rebase: you rewrite
history. The merge, by contrast, rewrites nothing — it adds one new commit with two parents that ties the
histories together. Both end with the same files, which is why `git diff` between them is empty.

**Real-world notes**
- **The golden rule:** rebase only commits that nobody else has built on. Your own feature branch: fine. `main`,
  `release/*`, or a branch a teammate pulled: no. If you'd already pushed the branch, publish the rebase with
  `git push --force-with-lease` — it refuses to overwrite commits on the server that you haven't seen.
- **Why teams prefer the rebase:** reviewers see only your changes, `git log` reads like a story, and
  `git bisect`/`git revert` work on clean, single-purpose commits. "Merge main into feature" commits add noise
  and make the PR diff harder to follow.
- **When merging is better:** long-lived shared branches, or when the history itself matters (an audit trail of
  exactly what was integrated when). Also, a rebase resolves conflicts *per commit*; with 30 commits that all
  touch a hot file, a single merge might be less work (and `git rerere` can help either way).
- Make it a habit: `git config --global pull.rebase true` turns `git pull` on a feature branch into fetch +
  rebase instead of fetch + merge. On GitHub, the PR page's **Update branch** button has an "Update with rebase"
  option, and **Rebase and merge** lands a PR linearly.
- `git range-diff` is the senior-dev way to review a force-pushed PR: it pairs up each old commit with its new
  version and shows only what really changed.
