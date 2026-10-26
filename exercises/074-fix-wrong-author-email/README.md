# Fix commits made with your personal email

Maya pings you: *"Your last commits on `feature/wishlist-share` show up as `night.owl.coder@mail.example` —
the compliance bot will block the PR, and you won't get credit in the contributor stats."* At some point you
set your personal email in this repo's config.

```
* Add share URL example          <- feature/wishlist-share   (personal email, NOT pushed)
* Document wishlist sharing                                   (personal)
* Escape user in share URL                                    (personal)
* Note slug TODO                                              (personal)
* Add wishlist share URL                                      (personal)
* Note wishlist hand-off in cart  <- main, origin/main         (Dev)
* Count wishlist items                                        (personal, already pushed!)
* Add items to wishlist                                       (personal, already pushed!)
* Add wishlist model                                          (you@brightcart.example)
* Initial storefront
```

See it yourself: `git log --format='%h %an <%ae> | committer %ce  %s' --all`

Your work email is **`you@brightcart.example`**.

## Your task

1. Fix the cause: this repo's `user.email` (repo-level config) must be `you@brightcart.example`.
2. Rewrite the **5 unpushed commits** on `feature/wishlist-share` so both **author and committer** email are
   `you@brightcart.example`. Same messages, same order, same code. `origin/main` must not change.
3. The 2 older commits are already shared — don't rewrite `main`. Instead commit a **`.mailmap`** on
   `feature/wishlist-share` that maps `night.owl.coder@mail.example` to `you@brightcart.example`, so
   `git shortlog -sne` and `git log --use-mailmap` show only your work identity.
4. End on `feature/wishlist-share`, clean working tree.

## You'll practice

`git config user.email`, `git rebase --exec` (`-x`) with `git commit --amend --no-edit --reset-author`,
the difference between author and committer, and `.mailmap` / `git check-mailmap`.
