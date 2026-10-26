cd repo
git fetch -q
git rebase -q origin/main
git push -q origin main
git config pull.rebase true
