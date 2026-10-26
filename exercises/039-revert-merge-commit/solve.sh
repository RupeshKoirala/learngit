cd repo
m=$(git log --merges --format=%H -1 --grep="feature/gift-cards")
git revert --no-edit -m 1 "$m" >/dev/null
./test.sh >/dev/null
git push -q origin main
