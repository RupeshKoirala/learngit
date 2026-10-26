new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as you
remember base
write src/banner.js \
  "// Free-shipping banner shown above the cart" \
  "const THRESHOLD_CENTS = 5000;" \
  "" \
  "function bannerText(cartTotal) {" \
  "  const missing = THRESHOLD_CENTS - cartTotal;" \
  "  if (missing <= 0) return 'You get free shipping!';" \
  "  return 'Add \$' + (missing / 100).toFixed(2) + ' more for free shipping';" \
  "}" \
  "" \
  "module.exports = { bannerText };"
git add src/banner.js
commit_staged "Add free shiping banner"
remember typo
# The stylesheet you forgot to `git add`:
write src/banner.css ".free-shipping-banner {" "  background: #e8f7ee;" "  color: #11633a;" "  padding: 8px 16px;" "  font-weight: 600;" "}"
