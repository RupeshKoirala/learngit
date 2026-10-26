See exactly which commits are affected: `git log --oneline --stat main..HEAD -- node_modules dist`.
Only unpushed commits are involved, so rewriting them is safe.
---
`git rm -r --cached node_modules dist` removes paths from the **index** (the next commit) but leaves them on disk.
You need to do that in *every* commit that added them — `git rebase -i main` with `edit` on those commits, then
`git rm -r --cached …`, `git commit --amend --no-edit`, `git rebase --continue`.
---
Or let rebase run it after every commit for you:
`git rebase -x 'git rm -r -q --cached --ignore-unmatch node_modules dist && git commit -q --amend --no-edit --allow-empty' main`
---
After the rewrite the files are untracked. Add `node_modules/` and `dist/` to `.gitignore`, commit it, and check
`git status` is clean and `git log --all --oneline -- node_modules dist` prints nothing.
