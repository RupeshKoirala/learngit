`A..B` means "commits reachable from B but not from A", i.e. *what B has that A doesn't*. `git log --oneline
main..origin/main` lists what a pull would bring in. Flip it for the opposite question.
`git rev-list --count <range>` counts instead of listing.
---
`A...B` (three dots) is the **symmetric difference**: commits on *either* side but not on both.
`git log --oneline --left-right main...origin/main` marks each commit `<` (only on main) or `>` (only on
origin/main). `git status -sb` sums it up as `[ahead 2, behind 3]`.
---
`--first-parent` follows only the first parent of each merge, i.e. the branch's own line, skipping the
commits a merge brought in: `git rev-list --count --first-parent main..feature/gift-cards`.
A range is just shorthand for exclusions: `A..B` = `B ^A`. You can exclude more than one ref:
`git rev-list --count origin/release/1.3 ^main ^origin/main`.
---
For the port question: `git log --oneline --cherry-mark origin/main...origin/release/1.3` marks commits whose
*patch* also exists on the other side with `=`, and the rest with `+`. Equivalently,
`--cherry-pick --right-only` hides the already-ported ones. Of what's left, the version bump isn't a fix.
```
q1=…  q2=…  q3=…  q4=…  q5=…      (one per line in ../ANSWER)
git tag needs-port <hash>
```
