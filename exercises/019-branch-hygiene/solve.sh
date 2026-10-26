cd repo
git switch -q main
git branch -q -d feature/search fix/typo-footer feature/old-promo-banner
git branch -q -D spike/graphql-experiment
git push -q origin --delete feature/search fix/typo-footer 2>/dev/null
git fetch -q --prune
