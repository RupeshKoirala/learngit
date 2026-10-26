# Solution

```bash
cd "$(./lg where)"
gh repo fork octocat/Spoon-Knife --clone       # origin = you/Spoon-Knife, upstream = octocat/Spoon-Knife
cd Spoon-Knife
git remote -v
gh repo set-default "$(gh api user -q .login)/Spoon-Knife"

gh repo sync "$(gh api user -q .login)/Spoon-Knife"   # fork's main <- upstream main (on GitHub)
git pull                                               # local main <- fork

git switch -c add-my-name
echo "Hello from $(gh api user -q .login)" >> README.md
git commit -am "Say hello"
git push -u origin add-my-name
gh pr create --repo "$(gh api user -q .login)/Spoon-Knife" --base main --head add-my-name --fill
```

**Why it works:** a fork is a server-side copy in the same "network" as the original, so commits and PRs can
flow between them. `--clone` also adds the original as `upstream`. `gh repo sync` fast-forwards your fork's
branch from its parent through the API. A PR always names a base repo + base branch and a head branch; here
both live in your fork.

**Real-world notes**
- Real contribution flow: read CONTRIBUTING.md and the issue first (comment "I'd like to work on this"),
  branch from a **fresh** upstream `main`, keep the PR small, and then open it with
  `gh pr create --repo upstream/repo --head you:branch`. Never work on your fork's `main` - keep it a clean
  mirror of upstream.
- Staying current during review: `git fetch upstream && git rebase upstream/main && git push --force-with-lease`.
- Maintainers can push to your PR branch if "Allow edits by maintainers" is ticked - don't be surprised.
- Fork PRs don't get the base repo's secrets in CI (`pull_request` from forks), which is why some checks show
  "awaiting approval" for first-time contributors.
- Companies use the same flow internally for repos you only read (inner source), or skip forks and give
  teams branch access with protection rules.
- Clean up practice forks when done: `gh repo delete <you>/Spoon-Knife` (needs `gh auth refresh -s delete_repo`).
