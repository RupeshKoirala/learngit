cd repo
bad=$(git log -S "Math.round" --format=%H -1 -- src/price.js)
git revert --no-edit "$bad" >/dev/null
./test.sh >/dev/null
git push -q origin main
