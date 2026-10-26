# git bisect by hand: who broke the checkout page?

Sam (PM) drops a screenshot into #frontend: **the "Place order" button has slid off the checkout card.**
Customers on the release candidate can barely find it. Release v1.4 was fine. Since then, **30 commits**
from four people have landed on `main`, nearly all of them tiny CSS tweaks. Reading every diff would take all
morning, and the commit messages won't help much (one is literally called "Fix Place order button
alignment"... and it's not that simple).

The team keeps a text mock-up of the page in `ui/checkout.txt`. A **good** checkout looks like this:

```
|----------------------------------------|
| Total (incl. tax)              $33.50  |
|                                        |
|             [ Place order ]            |   <- button INSIDE the card
| Free shipping over $50                 |
+----------------------------------------+
```

A **bad** one has the button outside the right edge of the card:

```
|                                        |  [ Place order ]
```

(Taglines, footers and prices change from commit to commit. Those don't matter, only the button does.)

## Your task

1. Use **`git bisect`** between `v1.4` (good) and `main` (bad). At each step, look at `ui/checkout.txt` and
   tell Git `good` or `bad`.
2. When Git names the first bad commit, tag it **`first-bad`**.
3. End the session properly: no bisect left in progress, and you're back on `main`. Don't change any
   commits.

With 30 commits, it should take about **5** checks (log₂ 30 ≈ 5).

## You'll practice

`git bisect start / good / bad / reset`, `git bisect log` and `git bisect visualize`, and the most useful habit
in debugging: **binary search over history** instead of guessing from commit messages.
