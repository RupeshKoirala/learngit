# Clone, inspect origin, and update without surprises

You're back from a week of holiday. Your laptop has a clone of the Brightcart repo (`repo/`) from before you
left, and the team has been busy. Before you write a line of code, you want to know **exactly** what changed
— not run `git pull` and hope.

The "GitHub" repository for this exercise is the bare repo `remotes/origin.git` in the sandbox.

```
remotes/origin.git (GitHub)              repo/ (your laptop, a week old)

* Add contributing guide      <- main    * Add shipping cost calculator  <- main, origin/main
* Free shipping on orders over 50        * Initial storefront
* Show prices with currency code
| * Start gift card redemption <- feature/gift-cards
|/
* Add shipping cost calculator
* Initial storefront
```

Notice that `origin/main` in your clone still says "Add shipping cost calculator": remote-tracking branches
are a **snapshot from your last fetch**, not a live view.

## Your task

1. A new hire asked what a fresh clone looks like. Make one: clone `remotes/origin.git` into a folder named
   `fresh` next to `repo` (i.e. `<sandbox>/fresh`), and look around in it (`git remote -v`, `git branch -a`).
2. In `repo/`, **download** the team's work without touching your own branches, then find out how many commits
   your `main` is behind `origin/main`. Write that number into the file `ANSWER` in the sandbox (`../ANSWER`).
3. Bring `main` up to date with a **fast-forward only** update — no merge commit, ever, on `main`.
4. Lena wants you to try her branch: create a local `feature/gift-cards` that **tracks** `origin/feature/gift-cards`.
5. Leave the working tree clean.

## You'll practice

`git clone`, `git remote -v`, `git branch -a / -r`, `git fetch`, `git status` / `git rev-list --count`
for ahead/behind, `git log main..origin/main`, `git merge --ff-only`, and `git switch <remote-branch-name>`.
