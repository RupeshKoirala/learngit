`git log --oneline --reverse main..feature/checkout-redesign` shows Lena's commits oldest first. Note the
hash of the **first** and **last** `a11y:` commit — they're consecutive, so you can pick them as a range.
---
`git cherry-pick A..B` means "commits reachable from B but not from A" — so it **excludes A**. To include
the first a11y commit, write `A^..B` (start from A's parent). Git applies them oldest first.
---
For release/2.0:
```bash
git switch release/2.0
git cherry-pick <first-a11y>^..<last-a11y>
```
For main, `-n` applies the changes to your index and working tree **without committing**, so you can
commit them together:
```bash
git switch main
git cherry-pick -n <first-a11y>^..<last-a11y>
git commit -m "Accessibility fixes for checkout audit"
```
---
You can avoid copying hashes: `git log --format=%h --grep='^a11y:' feature/checkout-redesign` lists them
(newest first). Something went wrong mid-pick? `git cherry-pick --abort` puts the branch back as it was.
