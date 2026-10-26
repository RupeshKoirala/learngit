# Ranges that confuse everyone

It's Monday standup. Sam (PM) asks you three things, and Maya (tech lead) adds two more:

> **Sam:** "If you pull now, how much new stuff comes in? And how much of *your* stuff is still only on your
> laptop?"
> **Maya:** "How many commits did *you* make on the gift-card branch, not counting Lena's UI commits you merged
> in? And release/1.3 has hotfixes. Which of them hasn't been ported to main yet?"

You've just run `git fetch`. **Don't pull, merge or rebase anything.** Answer from the graph using commit
ranges. This is where `..` and `...` trip up even experienced devs.

```
* Brand link colour              (origin/main)
* Clarify price units
* Fix VAT rounding on invoices   <- cherry-picked from release/1.3
| * Add release checklist        (main, not pushed)
| * Announce gift cards in README
|/
| * Export gift card API         (feature/gift-cards)
| *   Merge branch 'lena/gift-card-ui'
| |\
| | * Show gift card balance
| | * Gift card styles
| |/
| * Redeem gift cards at checkout
| * Add gift card model
|/
| * Fix crash on empty cart      (origin/release/1.3)
| * Fix VAT rounding on invoices
| * Bump version to 1.3.0
|/
* Add base styles
* ...
```

## Your task

Write your answers into `ANSWER` in the sandbox folder (`../ANSWER` from `repo`), one `key=value` per line:

```
q1=<number of commits a `git pull` would bring into your main>
q2=<number of commits on your main that origin/main doesn't have>
q3=<number of commits in the symmetric difference of main and origin/main>
q4=<number of commits on feature/gift-cards since it left main, following only its first parents>
q5=<number of commits on origin/release/1.3 that are on neither main nor origin/main>
```

Then tag the release hotfix whose change **still needs porting** to `origin/main` as **`needs-port`**. (The
VAT fix was already cherry-picked under a different hash. A version bump isn't a hotfix.)

`main`, `origin/main` and `feature/gift-cards` must stay exactly where they are.

## You'll practice

`git log A..B` vs `A...B`, `--left-right`, `--first-parent`, `^ref` exclusions with several refs,
`git rev-list --count`, and `--cherry-pick` / `--cherry-mark` to spot changes that exist under another hash.
