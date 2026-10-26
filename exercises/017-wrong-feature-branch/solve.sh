cd repo
git switch -q feature/wishlist
git cherry-pick feature/search-filters~2..feature/search-filters >/dev/null
git switch -q feature/search-filters
git reset -q --hard HEAD~2
