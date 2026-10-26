cd repo
git merge --abort
git config merge.conflictStyle diff3
git merge -q release/1.4 >/dev/null 2>&1 || true
write src/cart.js "// Shopping cart" "function addItem(cart, item) {" "  cart.items.push(item);" "  return cart;" "}" "" \
  "function lineTotal(item) {" "  return item.price * item.qty;" "}" "" \
  "function total(cart) {" "  return Math.round(cart.items.reduce((sum, i) => sum + lineTotal(i), 0));" "}" "" \
  "module.exports = { addItem, lineTotal, total };"
write src/price.js "// Price formatting" "function formatPrice(cents, currency = '\$') {" \
  "  if (cents < 0) return '-' + formatPrice(-cents, currency);" \
  "  return currency + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
git rm -q src/legacy-coupons.js
replace src/discount.js "expires < now" "expires <= now"
git add src/cart.js src/price.js src/discount.js
git commit -q --no-edit
