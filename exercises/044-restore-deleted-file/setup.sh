keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_repo repo
keep_everything
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
write src/coupons.js "// Coupons" "function couponValue(code) {" "  if (code === 'WELCOME5') return 500;" "  return 0;" "}" "" "module.exports = { couponValue };"
commit "Add coupon codes"
write src/legacy-banner.js "// Old promo banner, replaced by the CMS" "module.exports = { banner: 'SALE' };"
commit "Add promo banner"
day
as dev
write src/coupons.js "// Coupons" "const CODES = { WELCOME5: 500, BLACKFRIDAY: 1500 };" "" "function couponValue(code) {" "  return CODES[code] || 0;" "}" "" "module.exports = { couponValue };"
commit "Table-driven coupon codes"
as lena
write src/coupons.js "// Coupons" "const CODES = { WELCOME5: 500, BLACKFRIDAY: 1500 };" "" "function couponValue(code) {" \
  "  return CODES[String(code).toUpperCase()] || 0;" "}" "" "module.exports = { couponValue };"
commit "Make coupon codes case-insensitive"
day 3
as dev
git rm -q src/coupons.js src/legacy-banner.js
commit "Remove legacy coupon and banner code"
remember deleter
as lena
append src/cart.js "" "function itemCount(cart) {" "  return cart.items.reduce((n, i) => n + i.qty, 0);" "}"
commit "Add itemCount to cart"
as maya
append README.md "" "Release notes live in CHANGELOG.md"
commit "Mention the changelog"
as dev
write src/shipping.js "// Shipping" "function shippingCost(total) {" "  return total >= 5000 ? 0 : 499;" "}" "" "module.exports = { shippingCost };"
commit "Add shipping cost rules"
as you
remember main
