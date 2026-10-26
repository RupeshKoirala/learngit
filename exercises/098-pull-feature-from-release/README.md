# Pull a feature out of the release

`release/2.3` was cut two days ago and is being stabilized. This morning Sam (PM) wrote in #release:

> Legal hasn't signed off on **gift cards** (state-by-state rules on expiry). They must **not** ship in 2.3.
> Keep them on `main` — they'll go out in 2.4 once Legal is happy.

The gift-card work is **six commits, scattered** between other changes that *must* ship. All of them, and
only them, use the conventional-commit scope `(giftcards)`. Careful: `feat(cards): remember saved payment
cards` is a different feature and stays.

```
* fix(search): empty query no longer crashes            <- release/2.3 (you're here)
| * feat(reviews): star ratings                         <- main
| * feat(giftcards): refunds to gift card                  (main only, not on the release)
|/
* chore(release): 2.3.0-rc1
* feat(giftcards): show gift card balance in header
* perf(search): dedupe results
* feat(giftcards): gift card email template
* docs: support contact in README
* test(giftcards): balance tests
* fix(checkout): round tax correctly
* fix(giftcards): balance can't go negative
* feat(cards): remember saved payment cards
* feat(giftcards): apply gift card at checkout
* feat(search): typo tolerance
* feat(giftcards): gift card model
* chore(release): 2.2.0                                 (tag v2.2.0)
```

## Your task

1. On `release/2.3`, undo all six gift-card commits as **one single commit** on top of the branch (don't
   rewrite the release branch — QA and CI already use it).
2. Everything else must stay: saved payment cards, the search changes, the tax rounding fix, the README change,
   the `2.3.0-rc1` version and the release-branch fix.
3. The commit's subject must say it's a revert of gift cards (e.g. `Revert gift cards from 2.3`), and the body
   must list the **hashes of the six reverted commits** (7+ characters each) so anyone can trace it.
4. Don't touch `main`. Leave a clean working tree with no revert in progress.

## You'll practice

`git log --grep` with a precise pattern, `git revert --no-commit` with several commits, **why the order of
reverts matters**, `git revert --abort/--quit`, and the trap of merging a release branch that contains a revert
back into `main`.
