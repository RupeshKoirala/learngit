`cd "$(./lg where)"` then `gh repo fork octocat/Spoon-Knife --clone`. gh names the remotes for you:
`git -C Spoon-Knife remote -v`.
---
`gh repo sync <you>/Spoon-Knife` updates your fork's `main` on GitHub from upstream (like the "Sync fork"
button). Then `git pull` locally. Pure-git alternative: `git fetch upstream && git merge --ff-only upstream/main && git push`.
---
```
cd Spoon-Knife
gh repo set-default <you>/Spoon-Knife
git switch -c add-my-name
echo "Hello from <you>" >> README.md
git commit -am "Say hello"
git push -u origin add-my-name
```
---
`gh pr create --repo <you>/Spoon-Knife --base main --head add-my-name --fill`.
Opened one against octocat by accident? `gh pr close <N> --repo octocat/Spoon-Knife` and say sorry in a comment.
