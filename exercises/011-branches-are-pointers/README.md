# Branches are just pointers: create, switch, list, rename

It's your second week at Brightcart. Maya (tech lead) wants to see that you're fluent with branches before
she hands you real tickets. Her one-sentence lesson: *"A branch is a sticky note with a commit hash on it.
Creating one is free, moving one is cheap, and none of it touches your files unless you switch."*

```
* Fix typo in README                      <- fixtypo
* Add product search box                  <- main, origin/main
* Show prices with currency code
* Add free-shipping threshold
* Add removeItem to cart                  <- v1.0 (tag), release/1.0
* Initial storefront
```

(`origin/release/1.0` has one more commit from Maya that you've fetched but not pulled.)

## Your task

Inside `repo/`, using only branch commands (no new commits):

1. Create `hotfix/1.0.1` starting at the **tag** `v1.0`.
2. Create `experiment/shipping-rules` starting at the **older commit** `Add free-shipping threshold`
   (find its hash in the log).
3. Rename the badly named branch `fixtypo` to `fix/readme-typo` (its commit must come along).
4. Create `feature/wishlist` at the tip of `main` and **switch to it**. You should end on this branch.
5. Run `git branch -vv`. One local branch is *behind* its upstream. Write that branch's name into
   the file `../ANSWER` (i.e. `$LG_DIR/ANSWER`, next to `repo/`).

`main` must not move.

## You'll practice

`git branch <name> [start-point]`, `git switch` / `git switch -c`, `git branch -m`, `git branch -vv`,
`git log --oneline --graph --all`, and the idea that tags, branches and `HEAD` are all just names for commits.
