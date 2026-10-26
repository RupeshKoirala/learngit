new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
remember forkpoint

# Dev starts loyalty points from here...
git switch -q -c feature/loyalty-points
write src/loyalty.js "// Loyalty points: 1 point per whole dollar" "function pointsFor(totalCents) {" \
  "  return Math.floor(totalCents / 100);" "}" "" "module.exports = { pointsFor };"
commit "Add loyalty points calculation"
append README.md "" "Loyalty: earn 1 point per dollar."
commit "Document loyalty points"

# ...while main moves on
git switch -q main
as maya
write src/shipping.js "// Shipping rules" "const FREE_SHIPPING_THRESHOLD = 5000; // cents" "" \
  "function shippingCost(totalCents) {" "  if (totalCents >= FREE_SHIPPING_THRESHOLD) return 0;" "  return 499;" "}" "" \
  "module.exports = { shippingCost };"
commit "Add free-shipping threshold"

# your small fix, branched from the current tip of main
git switch -q -c fix/price-rounding
as you
replace src/price.js "\(cents \/ 100\)\.toFixed\(2\)" "(Math.round(cents) \/ 100).toFixed(2)"
commit "Round fractional cents before formatting"

# Lena stacked gift wrap on top of your fix because she needed it
git switch -q -c feature/gift-wrap
as lena
write src/giftwrap.js "// Gift wrap option" "const GIFT_WRAP_CENTS = 350;" "" \
  "function withGiftWrap(totalCents, wrap) {" "  return wrap ? totalCents + GIFT_WRAP_CENTS : totalCents;" "}" "" \
  "module.exports = { withGiftWrap };"
commit "Add gift wrap pricing"
append README.md "" "Gift wrap: \$3.50 per order."
commit "Document gift wrap"

git switch -q main
as you
remember main main
remember fix fix/price-rounding
remember gift feature/gift-wrap
remember loyalty feature/loyalty-points
