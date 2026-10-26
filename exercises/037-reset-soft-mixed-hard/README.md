# reset --soft / --mixed / --hard: squash, unstage, beware

You've been building free shipping on `feature/free-shipping`. Nothing is pushed yet, and the history is
three tiny commits nobody needs to read separately:

```
* export the threshold too     <- feature/free-shipping (HEAD)
* fix typo
* wip free shipping
* Add flat-rate shipping       <- main
```

Your working directory is messy too (`git status`):

- `notes.txt` — your personal scratch notes — got **staged** by a careless `git add .`
- `src/price.js` has a half-finished multi-currency **experiment** you've decided to throw away

## Your task

1. **Unstage** `notes.txt` without deleting it. It must stay on disk as an untracked file, with its contents.
2. Combine the 3 branch commits into **one** commit called `Add free shipping threshold`, using
   `git reset --soft`. The code in that commit must be exactly what the 3 commits produced — no notes, no
   experiment.
3. Throw away the experiment in `src/price.js` (it should match the committed version again).
4. Which `reset` mode (`soft`, `mixed` or `hard`), run as your very *first* command, would have **destroyed**
   `notes.txt` for good? Write that one word into the file `ANSWER` in the sandbox folder (`../ANSWER`).

When you're done, `git status --short` should show only `?? notes.txt`, and `main` must not move.

## You'll practice

The three modes of `git reset` — what each does to the **branch pointer**, the **index** (staging area) and
the **working tree** — plus `git restore` for single files, and the classic "squash my last N local commits"
trick with `reset --soft HEAD~N`.
