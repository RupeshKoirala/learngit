# Stash basics: untracked files, named stashes, apply and drop

You're halfway through result ranking on `feature/search`: `src/search.js` is modified and there's a
brand-new, **untracked** `src/search-ui.js`. Then Maya pings you:

> Ticket #812 — customers typing "snekers" find nothing. Didn't you try fuzzy matching a while ago? Put that
> experiment back in your working tree so we can look at it together. Don't lose your ranking work.

`git stash list` shows you've been here before:

```
stash@{0}: On feature/search: experiment: fuzzy matching
stash@{1}: WIP on feature/search: 1a2b3c4 Add basic product search      <- what was this again?
```

## Your task

1. Stash **all** your current work — including the untracked `src/search-ui.js` — as a stash named
   **`search: half-done ranking`**.
2. Find out what the unnamed `WIP on …` stash contains. Write the **path of the file it changes** into
   `ANSWER` in the sandbox folder (`echo some/path > ../ANSWER`). It's leftover debug logging: **drop** it.
3. **Apply** (not pop) the `experiment: fuzzy matching` stash to your working tree. It must stay in the
   stash list — you may want it again.

At the end: `git stash list` has exactly 2 entries (your ranking stash and the fuzzy experiment), your
working tree shows the fuzzy experiment, and `src/search-ui.js` is safely inside your ranking stash.
No commits.

## You'll practice

`git stash push -u -m`, `git stash list`, `git stash show -p stash@{n}`, `git stash apply stash@{n}`,
`git stash drop stash@{n}`, and why stash indexes shift.
