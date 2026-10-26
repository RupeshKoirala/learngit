cd repo
git config rerere.enabled true
git merge main >/dev/null 2>&1 || true            # conflict in src/price.js (expected)
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents, currency = 'USD') {" \
  "  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(cents / 100);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
git add src/price.js
git commit -q --no-edit                            # "Recorded resolution for 'src/price.js'"
git reset -q --hard HEAD~1                         # Maya: no merge commits, please
git rebase main >/dev/null 2>&1 || true            # stops on the same conflict, rerere fixes the file
grep -q "currency = 'USD'" src/price.js            # proof that rerere replayed the resolution
git add src/price.js
git rebase --continue
