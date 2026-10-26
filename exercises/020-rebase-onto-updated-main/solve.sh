cd repo
git branch compare/merge feature/free-shipping
git switch -q compare/merge
git merge -q --no-edit main
git switch -q feature/free-shipping
git rebase -q main
