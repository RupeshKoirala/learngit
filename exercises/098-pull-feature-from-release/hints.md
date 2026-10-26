List exactly the gift-card commits on the release branch:
`git log --oneline --grep '(giftcards)' --fixed-strings release/2.3` (or `-E --grep '^[a-z]+\(giftcards\)'`).
A loose `--grep card` would also catch the saved-payment-cards commit. You should see six commits on the
release branch (the refunds commit is only on `main`).
---
`git revert --no-commit <c1> <c2> …` applies several reverts to your index and working tree **without
committing**, so you can make one commit at the end. Git reverts them in the order you list them.
---
Order matters: revert **newest first**. If you revert "gift card model" (which created `src/giftcards.sh`)
before the later commits that modified that file, Git hits a modify/delete conflict. `git log` already lists
newest first, so: `git revert --no-commit $(git log --format=%h --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)`.
Made a mess? `git revert --abort`.
---
Then commit with a traceable message, e.g.:
```
git commit -m "Revert gift cards from 2.3 (Legal sign-off pending)" \
  -m "$(git log --format='Reverts %h %s' --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)"
```
Check: `git diff v2.2.0 release/2.3 --stat` mentions no gift-card files, and `git diff main release/2.3` is
everything you expect.
