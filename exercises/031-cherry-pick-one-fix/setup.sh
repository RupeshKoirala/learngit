new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as lena; write src/price.js \
           "// Price formatting" \
           "// BUG: negative amounts render as \$-5.00 instead of -\$5.00 (ticket #311)" \
           "function formatPrice(cents) {" \
           "  return '\$' + (cents / 100).toFixed(2);" \
           "}" "" "module.exports = { formatPrice };"
         write src/refunds.js "// Order history: refunds are shown as negative amounts" \
           "const { formatPrice } = require('./price');" \
           "function refundLine(cents) { return 'Refund ' + formatPrice(-cents); }" \
           "module.exports = { refundLine };"
         commit "Show refunds in order history"

# Dev's unfinished gift-card branch: one real fix buried among WIP commits
git switch -q -c feature/gift-cards
as dev
write src/giftcard.js "// Gift cards (WIP)" "function GiftCard(code, balance) {" "  return { code, balance };" "}"
commit "WIP gift card model"
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  const sign = cents < 0 ? '-' : '';" \
  "  return sign + '\$' + (Math.abs(cents) / 100).toFixed(2);" \
  "}" "" "module.exports = { formatPrice };"
commit "Fix formatPrice for negative amounts"
remember fix
append src/giftcard.js "" "function redeem(card, total) {" "  // TODO: partial redemption, expiry" "  return Math.max(0, total - card.balance);" "}"
commit "WIP gift card redemption at checkout"
append src/giftcard.js "const TEST_CARD = GiftCard('GC-TEST-0000', 100000); // remove before merge!"
commit "WIP: hardcode test card"
remember gift

# main moved on meanwhile
git switch -q main
as lena; write src/banner.js "// Free shipping banner" "function banner(total) { return total >= 5000 ? 'Free shipping!' : ''; }" "module.exports = { banner };"
         commit "Add free-shipping banner"
remember main
as you
