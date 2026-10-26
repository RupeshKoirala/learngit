# Solution

```bash
cd "$(./lg where)"
gh pr create --head hotfix/round-totals --base main --fill
gh pr merge <hotfix-N> --squash --delete-branch
gh pr create --head feature/sale-banner --base main --fill
gh pr view <M> --json mergeable          # CONFLICTING

git fetch origin
git switch feature/sale-banner
git rebase origin/main                   # CONFLICT (content): Merge conflict in CHANGELOG.md
# edit CHANGELOG.md -> keep both lines, remove markers
git add CHANGELOG.md
git rebase --continue
./test.sh
git push --force-with-lease
gh pr view <M> --json mergeable          # MERGEABLE
gh pr merge <M> --squash --delete-branch
```

Merge variant: `git merge origin/main`, resolve, `git commit`, `git push` (no force needed).

**Why it works:** GitHub can only merge a PR if its branch and `main` combine without conflicts. You
reproduce that combination locally, decide the right content once, and push the updated branch; the PR
updates itself and is mergeable again.

**Rebase or merge `main` into the PR branch?**
- **Rebase** keeps the branch a clean line on top of `main` and is what squash/rebase-merge teams usually do.
  It rewrites the branch, so push with `--force-with-lease` (refuses if someone else pushed meanwhile) and
  tell co-authors to re-pull. Reviewers lose "changes since last review" context a bit.
- **Merge `main` in** never rewrites, safe when several people push to the branch; GitHub's **Update branch**
  button does exactly this (or "Update with rebase" from its dropdown).

**Real-world notes**
- GitHub's web **conflict editor** ("Resolve conflicts" button) handles simple text conflicts in the
  browser and commits a merge of `main` into your branch. It's fine for a changelog line; for code, resolve
  locally so you can run the tests.
- Changelog conflicts are so common that teams switch to one-file-per-change (`changes/123.md`, changesets)
  or generate notes from PR titles (exercise 109).
- `git config --global rerere.enabled true` remembers resolutions you've made before.
- Fewer conflicts: small PRs, merge often, rebase your branch on `main` daily, and the "require branches to be
  up to date" protection setting surfaces conflicts before merge.
