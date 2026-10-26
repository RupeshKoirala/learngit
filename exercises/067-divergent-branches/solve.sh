cd repo
git fetch -q
git switch -q main
git pull -q --ff-only
git switch -q feature/reviews
git pull -q --rebase
git push -q
git switch -q release/2.5
git pull -q --no-rebase --no-edit
git push -q
git config pull.rebase true
git config branch.release/2.5.rebase false
git switch -q main
