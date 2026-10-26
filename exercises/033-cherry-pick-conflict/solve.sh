cd repo
git switch -q main
qty=$(git log --format=%H --grep='^Fix total' release/3.1)
price=$(git log --format=%H --grep='^Fix formatPrice' release/3.1)
git cherry-pick "$qty" >/dev/null 2>&1 || true
write src/cart.js \
  "// Shopping cart" \
  "function addItem(cart, item) {" \
  "  cart.items.push(item);" \
  "  return cart;" \
  "}" \
  "" \
  "function lineTotal(item) {" \
  "  return item.price * (item.qty || 1);" \
  "}" \
  "" \
  "function total(cart) {" \
  "  return cart.items.map(lineTotal).reduce((a, b) => a + b, 0);" \
  "}" \
  "" \
  "module.exports = { addItem, lineTotal, total };"
git add src/cart.js
git cherry-pick --continue >/dev/null
git cherry-pick "$price" >/dev/null
