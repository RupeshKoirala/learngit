cd repo
git pull -q --ff-only
bad=$(git log --format=%H -1 --grep='^Add currency support to formatPrice$')
git revert --no-edit "$bad" >/dev/null
git show "$bad:src/price.js" | sed 's/Math.round(cents \/ 100).toFixed(0)/(cents \/ 100).toFixed(2)/' > src/price.js
sh ./test.sh >/dev/null
git commit -q -am "Add currency support to formatPrice (keep cents)"
git push -q
