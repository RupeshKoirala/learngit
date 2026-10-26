new_repo repo
brightcart_skeleton
rm src/price.js
as maya; commit "Initial storefront"
as dev
write src/price.js "// Price formatting" "function formatPrice(cents) {" "  return '\$' + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Add price formatting"
remember price_created
as lena; replace src/price.js "function formatPrice\(cents\) \{\n" "function formatPrice(cents) {\n  if (cents < 0) return '-' + formatPrice(-cents);\n"
         commit "Format negative prices"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as maya; replace src/price.js "\(cents \/ 100\)" "(Math.round(cents) \/ 100)"
         commit "Round before formatting"
as you
remember start
