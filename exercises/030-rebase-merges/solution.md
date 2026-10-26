# Solution

```bash
# 1. The default: flatten
git branch flat/promo-banner
git rebase main flat/promo-banner          # switches to flat/promo-banner and rebases it
git log --oneline --graph main..           # 5 commits in a straight line, merge gone

# 2. Keep the topology
git switch feature/promo-banner
git rebase --rebase-merges main            # or: git rebase -r main
git log --oneline --graph main..
git diff flat/promo-banner feature/promo-banner     # empty
```

```
* Rotate banner messages every 8 seconds          <- feature/promo-banner
*   Merge branch 'banner-styles' into feature/promo-banner
|\
| * Add dark-mode banner theme
| * Add banner color themes
* | Add close button to banner
|/
* Add promo banner component
* Add removeItem to cart                          <- main
```

What `git rebase -i -r main` shows you:

```
label onto

# Branch: banner-styles
reset onto
pick 1111111 Add promo banner component
label branch-point
pick 2222222 Add banner color themes
pick 3333333 Add dark-mode banner theme
label banner-styles

reset branch-point # Add promo banner component
pick 4444444 Add close button to banner
merge -C 5555555 banner-styles # Merge branch 'banner-styles' into feature/promo-banner
pick 6666666 Rotate banner messages every 8 seconds
```

**Why it works:** a normal rebase replays `main..HEAD` as a *list* — it drops merge commits (they have no single
"patch") and linearises their parents' commits. `--rebase-merges` instead replays the *graph*: `label` marks
commits, `reset` moves back to a label to build another side, and `merge -C <old-merge>` creates a new merge
with the original message. If the original merge had conflict resolutions, Git redoes the merge and you may have
to resolve again (`rerere` helps) — the old resolution isn't copied automatically.

**When it matters (and when it doesn't)**
- Keep merges when they carry meaning: a sub-team's branch integrated as a unit, a release branch merged back,
  an audit trail of "this PR was merged here", or tooling that reads merge commits (changelogs, `git log
  --first-parent` views).
- Flatten when the merges are noise — typically "Merge branch 'main' into my-feature" commits from keeping a
  branch up to date. Flattening those away is exactly what you want (and a plain rebase does it for you).
- Never rebase a long-lived shared branch like `develop` or `release/*` at all; merges there are the history.

**Real-world notes**
- `git log --first-parent main` shows one line per merged PR on merge-commit-based teams — another reason merges
  can be valuable.
- `--rebase-merges=rebase-cousins` also rebases side branches that didn't start from the branch's own history.
- Older advice mentions `--preserve-merges`: it was buggy, deprecated, and removed in Git 2.34. Use `-r`.
- If you find yourself needing this often, ask whether sub-PRs into feature branches are the best workflow;
  stacked branches (exercise 027) are often simpler.
