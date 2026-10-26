# The Git mental model (read this first — 15 minutes)

Almost every "Git is confusing" moment disappears once you hold this picture in your head.

## 1. A commit is a snapshot plus a pointer to its parent

A commit stores **the whole project as it looked** (not a diff), plus metadata: author, date, message, and the
hash of its **parent** commit(s). Its own hash (like `a1b2c3d`) is computed from all of that, so:

- changing *anything* — message, content, parent, date — creates a **new** commit with a new hash;
- "rewriting history" (amend, rebase, filter-repo) never edits commits; it makes new ones and moves pointers.

```
A <- B <- C          each commit points back to its parent
```

A **merge commit** simply has two parents.

## 2. Branches and tags are sticky notes

A branch is a file containing one commit hash. That's it. `main` → `C`.

- Committing on a branch makes a new commit whose parent is the old tip, then **moves the sticky note forward**.
- Creating a branch is instant and free: you just add a new sticky note.
- Deleting a branch deletes the note, **not the commits** (they stay reachable via the reflog for ~90 days).
- A **tag** is a sticky note that never moves (annotated tags also carry a message, author and date).

## 3. HEAD is "you are here"

`HEAD` usually points at a **branch** (`HEAD → main → C`). New commits move that branch.
If HEAD points straight at a commit (after `git checkout <hash>` or a tag), you're in **detached HEAD**: commits
you make there belong to no branch and are easy to lose — create a branch to keep them (exercise 018).

## 4. The three areas

```
working tree  --git add-->  staging area (index)  --git commit-->  repository (commits)
     ^                                                                    |
     +----------------------- git restore / switch -----------------------+
```

- **Working tree**: the files you edit.
- **Index / staging area**: the exact snapshot your *next* commit will be. `git add` copies changes into it.
- **Repository**: the commits.

`git diff` = working tree vs index. `git diff --staged` = index vs last commit.

## 5. Remotes are just other repositories

`origin` is a nickname for a URL. `origin/main` is your **local, read-only copy** of where `main` was on origin
the last time you fetched. Nothing about remotes updates by itself:

- `git fetch` — download new commits and move `origin/*` sticky notes. Safe, always.
- `git pull` — `fetch` + integrate (`merge` or `rebase`) into your branch.
- `git push` — upload commits and ask origin to move its branch. Refused if it would lose commits (non-fast-forward)
  unless you force.

## 6. Merge vs rebase in one picture

```
      D---E  feature                  merge:   A---B---C-------M  main
     /                                               \       /
A---B---C  main                                       D-----E

                                      rebase:  A---B---C---D'---E'  feature
```

**Merge** ties two histories together with a new commit; nothing is rewritten.
**Rebase** replays your commits on top of the new base, creating **new** commits (`D'`, `E'`) — clean and linear,
but it rewrites history, so only do it to commits nobody else has built on.

## 7. Nothing is really lost (for a while)

Every time HEAD or a branch moves, Git writes it to the **reflog** (`git reflog`). Commits that no branch points
to are still there until garbage collection (default ~30–90 days). So after a bad reset, rebase or branch
delete: `git reflog`, find the hash, `git branch rescue <hash>`. Uncommitted work that was never added, however,
*can* be lost — commit early, commit often.

## 8. The golden rule

> Rewrite your own unshared history as much as you like. Never rewrite history others have pulled
> (shared `main`, release branches) — use `git revert` there.

Keep this page open while you do the first module. Run `./lg graph` constantly — watching the sticky notes move
is how it sinks in.
