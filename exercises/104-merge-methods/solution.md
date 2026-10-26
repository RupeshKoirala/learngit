# Solution

```bash
cd "$(./lg where)"
for b in demo/merge-commit demo/squash demo/rebase; do gh pr create --head "$b" --base main --fill; done
gh pr list                                       # say #7, #8, #9
gh pr merge 7 --merge  --delete-branch
gh pr merge 8 --squash --delete-branch
gh pr merge 9 --rebase --delete-branch
git switch main && git pull
git log --graph --oneline -10
```

```
* 3c1f... Search is case-insensitive              <- rebase: Maya's 2 commits, new hashes
* 9ab2... Add product search
* 77de... Add product reviews (#8)                <- squash: 1 commit, "fix typo" folded in
*   51aa... Merge pull request #7 from you/demo/merge-commit
|\
| * e0c9... Export wishlist helpers               <- merge: original commits kept
| * 4b12... Add wishlist module
|/
* ...
```

```bash
gh repo edit --enable-merge-commit=false --enable-squash-merge --delete-branch-on-merge
```

**Why it works:** **merge** creates a new commit with two parents, so the branch's commits keep their
hashes and the branch shape is visible. **Squash** applies the whole PR diff as one new commit on `main`
(title + `(#N)`); the branch's own commits never reach `main`. **Rebase** replays each commit on top of
`main` - GitHub always re-creates them (new committer/hash), even when a fast-forward was possible.

**When teams choose each**
- **Squash** (most product teams): one commit per PR, clean `git log`, trivial reverts (exercise 110), WIP
  noise disappears. Cost: big PRs become one huge commit; the branch can't be merged "again" because its commits
  aren't in `main` - delete it after merging (hence auto-delete), and stacked PRs need a rebase (113).
- **Rebase**: linear history *and* individual commits - good when authors curate commits (`rebase -i`, 022).
  Cost: hashes change, so "is my commit in main?" by hash fails; every commit should pass tests (bisect).
- **Merge commit**: keeps true history, best for long-lived branches (release -> main, upstream syncs) and when
  commit hashes must survive (signed commits, cross-repo references). Cost: noisy graph.
- Leads write the choice down (CONTRIBUTING.md) and **enforce** it with the repo setting and "require linear
  history" (106) - a policy nobody can accidentally violate beats a wiki page.
- With squash, the PR **title** becomes the commit subject: make titles good (Conventional Commits like
  `feat: add wishlist` feed changelogs and release notes).
