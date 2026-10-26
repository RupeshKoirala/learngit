# You pushed a commit that breaks price formatting; Maya pulled it and pushed on top. Lena pulled too.
new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
write test.sh "#!/bin/sh" "# fake test runner (no Node needed)" \
  "if grep -rq 'BUG' src; then echo 'tests FAILED'; exit 1; fi" \
  "grep -q 'toFixed(2)' src/price.js || { echo 'tests FAILED: formatPrice must keep cents (19.99, not 20)'; exit 1; }" \
  "echo 'tests passed'"
chmod +x test.sh
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git
git push -q -u origin main

as dev;  append src/cart.js "" "function count(cart) { return cart.items.length; }"; commit "Add cart item count"
as you
write src/price.js "// Price formatting" \
  "function formatPrice(cents, currency) {" \
  "  const symbol = currency === 'EUR' ? 'EUR ' : '\$';" \
  "  return symbol + Math.round(cents / 100).toFixed(0);" \
  "}" "" "module.exports = { formatPrice };"
commit "Add currency support to formatPrice"
remember bad
git push -q

# the team pulls your commit and builds on top of it
git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/.team/maya"
git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/.team/lena"
( cd "$LG_DIR/.team/maya" && as maya &&
  write src/header.js "// Header" "const { total } = require('./cart');" "function headerTotal(cart) { return total(cart); }" "module.exports = { headerTotal };" &&
  commit "Show cart total in header" && git push -q && remember maya )
as you
