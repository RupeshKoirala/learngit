cd repo
git branch flat/promo-banner feature/promo-banner
git rebase -q main flat/promo-banner
git switch -q feature/promo-banner
git rebase -q --rebase-merges main
