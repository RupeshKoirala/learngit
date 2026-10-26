cart_with_guard() {   # cart_with_guard <guard line>
  write src/cart.js \
    "// Shopping cart" \
    "function addItem(cart, item) {" \
    "  cart.items.push(item);" \
    "  return cart;" \
    "}" \
    "" \
    "function total(cart) {" \
    "$1" \
    "  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);" \
    "}" \
    "" \
    "module.exports = { addItem, total };"
}

new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/currency
as you
cart_with_guard "  if (!cart.items) return 0;"
commit "Fix total() crashing on a cart without items"
write src/price.js "// Price formatting" "function formatPrice(cents, symbol = '\$') {" "  return symbol + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Support a currency symbol in formatPrice"
write src/summary.js "// Order summary line shown at checkout" "const { total } = require('./cart');" "const { formatPrice } = require('./price');" "" "function summaryLine(cart, symbol) {" "  return 'Total: ' + formatPrice(total(cart), symbol);" "}" "" "module.exports = { summaryLine };"
commit "Show the order total in the shop's currency"
remember original

git switch -q main
day
# Production broke; Maya shipped her own version of your fix straight to main.
as maya; cart_with_guard "  if (!cart.items || cart.items.length === 0) return 0;"
         commit "Hotfix: total() crashes when a cart has no items"
as lena; write src/price.js "// Price formatting" "function formatPrice(cents) {" "  const sign = cents < 0 ? '-' : '';" "  return sign + '\$' + (Math.abs(cents) / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
         commit "Show refunds as negative prices"

git switch -q feature/currency
