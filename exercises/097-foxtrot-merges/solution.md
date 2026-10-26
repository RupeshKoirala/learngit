# Solution

```bash
git log --graph --oneline origin/main
git log --first-parent --oneline origin/main     # PR #51 is missing; "Fix typo in footer" shows up instead
git log --merges --format='%h  parents: %p  %s' origin/main
# ff9047b  parents: c2d475f 559ff03  Merge branch 'main' of github.com:brightcart/storefront
git log --oneline -1 ff9047b^1                   # Fix typo in footer          <- Jo's local commit
git log --oneline -1 ff9047b^2                   # Merge pull request #51      <- the real mainline
echo ff9047b > ../ANSWER

# your own, unpushed foxtrot
git rebase origin/main                           # drops the merge, replays "Update shipping copy" on top
git log --oneline origin/main..main              # exactly one commit
git push
git config pull.rebase true                      # or: git config pull.ff only
```

**What happened:** `git pull` = `fetch` + `merge`. Merging always makes *your current branch* the first parent.
When you're on `main` with a local commit, "your branch" is your stale local `main`, so the real, shared
mainline becomes the **second** parent. Push that, and every tool that follows first parents —
`git log --first-parent`, `git bisect --first-parent`, release-note scripts, `git describe` heuristics,
"what PRs landed?" dashboards — now walks through Jo's private commit and skips PR #51. The graph is
"correct", but the mainline story is broken. It's called a foxtrot because the graph's shape (step forward,
step sideways, cross back) resembles the dance diagram.

**Why the fix works:** your merge isn't pushed, so you can rewrite it. `git rebase origin/main` takes the
commits in `main` that aren't in `origin/main` — only your shipping-copy commit (rebase skips merge commits by
default) — and replays them on top, producing a linear, fast-forwardable push. The pushed foxtrot stays:
rewriting a shared `main` costs far more than a wrinkle in history. Write it down instead (release notes
fixed by hand this once).

**Real-world notes**
- **Prevent it in the tool, not in people's heads.** On GitHub, protect `main`: require pull requests (no
  direct pushes means no foxtrots at all) and optionally **Require linear history**, which only allows
  squash/rebase merges — the server rejects any pushed merge commit. Rulesets can enforce the same for
  `release/*`.
- **Developer defaults:** `git config --global pull.rebase true` (or `pull.ff only`, which refuses to merge
  and makes you choose) belongs in your onboarding docs — it would have saved Jo.
- **Detection script for CI:** for every new commit on `main`, check that the old tip is still on the first-parent chain:
  `git rev-list --first-parent <new-tip> | grep -qx <old-tip>` — if not, someone pushed a foxtrot; fail the build.
- **Same trap, other direction:** fast-forward landing a feature branch that has merged `main` into itself also
  hands the first-parent chain to the feature branch. Land with `--no-ff` (exercise 096) or squash.
