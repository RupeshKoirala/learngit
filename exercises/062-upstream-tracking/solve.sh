cd repo
git push -q -u origin feature/wishlist
git branch -q -u origin/hotfix/tax-rounding hotfix/tax-rounding
git rev-list --count hotfix/tax-rounding..hotfix/tax-rounding@{u} > ../ANSWER
git switch -q hotfix/tax-rounding
git merge -q --ff-only @{u}
git branch --unset-upstream experiment/search-ranking
git config push.autoSetupRemote true
git switch -q chore/update-deps
git push -q
git switch -q main
