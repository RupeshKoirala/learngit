# Foxtrot merges and first-parent history

Brightcart lands every change through a pull request, so `main` reads like a list of PRs:

```bash
git log --first-parent --oneline origin/main    # one line per PR — or so everyone thought
```

Sam (PM) generates the release notes with exactly that command, and he's confused: **PR #51 (loyalty points)
is missing**, even though it was merged and is in the code. Something broke `main`'s *first-parent chain*.

Someone committed straight on `main`, got a rejected push, ran a plain `git pull` (which creates a merge with
**their** commit as the first parent and the real `main` as the second) and pushed. That's a **foxtrot merge**:
history-wise, the team's mainline became a side branch.

And you're about to do the same thing: you committed `Update shipping copy` on `main`, your push was rejected,
and you ran `git pull`. Run `git log --graph --oneline -8` and compare with `git log --first-parent --oneline -8`.

## Your task

1. Find the foxtrot merge that is already on `origin/main` (the commit whose **first** parent is *not* the
   previous mainline commit). Write its hash into the file `ANSWER` (sandbox folder, next to `repo/`).
   It's pushed and shared, so **don't** try to rewrite `origin/main`.
2. Fix *your* unpushed foxtrot: your local `main` must be `origin/main` + your one commit on top, with no merge
   commit — then push it.
3. Make sure a plain `git pull` in this repo can't create a foxtrot again: set `pull.rebase` (or `pull.ff=only`)
   in this repository's config.
4. Leave a clean working tree.

## You'll practice

`git log --first-parent`, `--merges`, `%P` (parents) in `--format`, `^1`/`^2` parent syntax, `git rebase` to
linearise an unpushed merge, `pull.rebase` / `pull.ff`, and why GitHub's "Require linear history" exists.
