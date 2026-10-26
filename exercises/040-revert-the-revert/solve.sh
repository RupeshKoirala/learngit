cd repo
rv=$(git log --format=%H -1 --grep='^Revert "Merge branch' main)
git revert --no-edit "$rv" >/dev/null
git merge -q --no-edit origin/feature/gift-cards
./test.sh >/dev/null
git push -q origin main
