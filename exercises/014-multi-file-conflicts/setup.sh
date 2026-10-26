new_repo repo
brightcart_skeleton
write src/legacy-coupons.js "// Legacy coupon codes (pre-2025)" "function couponValid(coupon, now) {" \
  "  if (coupon.expires < now) return false;" "  return coupon.active;" "}" "" "module.exports = { couponValid };"
write CHANGELOG.md "# Changelog" "" "## 1.4.0" "- Wishlist" "- Legacy coupon codes"
as maya; commit "Brightcart 1.4.0"
git tag -a v1.4.0 -m "Release 1.4.0"

# ---- release/1.4: hotfixes shipped to customers last week ------------------------------------
git switch -q -c release/1.4
as dev
write src/cart.js "// Shopping cart" "function addItem(cart, item) {" "  cart.items.push(item);" "  return cart;" "}" "" \
  "function total(cart) {" "  return Math.round(cart.items.reduce((sum, i) => sum + i.price * i.qty, 0));" "}" "" \
  "module.exports = { addItem, total };"
commit "Round cart totals to whole cents"
write src/price.js "// Price formatting" "function formatPrice(cents) {" "  if (cents < 0) return '-' + formatPrice(-cents);" \
  "  return '\$' + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Format refunds (negative amounts) correctly"
replace src/legacy-coupons.js "expires < now" "expires <= now"
commit "Coupons expire at their expiry instant, not after"
write CHANGELOG.md "# Changelog" "" "## 1.4.1" "- Fix rounding of cart totals" "- Fix negative price formatting" \
  "- Fix coupon expiry off-by-one" "" "## 1.4.0" "- Wishlist" "- Legacy coupon codes"
as bot; commit "Release 1.4.1"
git tag -a v1.4.1 -m "Release 1.4.1"

# ---- main: the team kept building ---------------------------------------------------------------
git switch -q main
as maya
write src/cart.js "// Shopping cart" "function addItem(cart, item) {" "  cart.items.push(item);" "  return cart;" "}" "" \
  "function lineTotal(item) {" "  return item.price * item.qty;" "}" "" \
  "function total(cart) {" "  return cart.items.reduce((sum, i) => sum + lineTotal(i), 0);" "}" "" \
  "module.exports = { addItem, lineTotal, total };"
commit "Extract lineTotal helper"
as lena
write src/price.js "// Price formatting" "function formatPrice(cents, currency = '\$') {" \
  "  return currency + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Support a currency symbol in formatPrice"
as dev
write src/discount.js "// Discounts and coupons (replaces src/legacy-coupons.js)" "function couponValid(coupon, now) {" \
  "  if (coupon.expires < now) return false;" "  return coupon.active;" "}" "" \
  "function applyPercent(total, pct) {" "  return Math.round(total * (100 - pct) / 100);" "}" "" \
  "module.exports = { couponValid, applyPercent };"
git rm -q src/legacy-coupons.js
commit "Replace legacy coupons with the discount module"
remember main main

# ---- Jo started the back-merge, panicked, and left it half done -----------------------------------
as jo
git merge release/1.4 >/dev/null 2>&1 || true
git checkout -q --theirs src/cart.js     # "just take the release version" (drops lineTotal!)
git add src/cart.js
as you
