new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

# You start a feature from today's main.
git switch -q -c feature/free-shipping
as you
write src/shipping.js "// Shipping costs (in cents)" "const FLAT_RATE = 499;" "" "function shippingCost(cart) {" "  return FLAT_RATE;" "}" "" "module.exports = { shippingCost };"
commit "Add flat-rate shipping cost"
write src/shipping.js "// Shipping costs (in cents)" "const FLAT_RATE = 499;" "const FREE_SHIPPING_MIN = 5000;" "" "function shippingCost(cart, subtotal) {" "  if (subtotal >= FREE_SHIPPING_MIN) return 0;" "  return FLAT_RATE;" "}" "" "module.exports = { shippingCost, FREE_SHIPPING_MIN };"
commit "Free shipping on orders over \$50"
remember original

# Overnight, the team merges their own work into main.
git switch -q main
day
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as lena; write src/price.js "// Price formatting" "function formatPrice(cents) {" "  return '\$' + (cents / 100).toLocaleString('en-US', { minimumFractionDigits: 2 });" "}" "" "module.exports = { formatPrice };"
         commit "Format prices with thousands separators"

git switch -q feature/free-shipping
