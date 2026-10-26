new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as you
remember start

# Ignored local stuff that must survive (it's ignored by .gitignore):
write .env "PAYMENT_API_KEY=local-dev-key"
write node_modules/left-pad/index.js "module.exports = (s, n) => String(s).padStart(n);"

# 1) A failed experiment in price.js -> throw it away
write src/price.js \
  "// Price formatting" \
  "// EXPERIMENT: Intl.NumberFormat everywhere?? breaks the tests, revisit later" \
  "function formatPrice(cents, locale) {" \
  "  return new Intl.NumberFormat(locale || 'en-US', { style: 'currency', currency: 'XXX' }).format(cents);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"

# 2) Real work in progress in cart.js, staged too early -> unstage it, keep the edit
replace src/cart.js "module.exports = \{ addItem, total \};" "function applyCoupon(cart, coupon) {\n  cart.coupon = coupon;\n  return cart;\n}\n\nmodule.exports = { addItem, total, applyCoupon };"
git add src/cart.js

# 3) The new file you're building -> keep it (untracked)
write src/coupon.js "// Coupon validation" "function isValidCoupon(code) {" "  return /^[A-Z0-9]{4,12}\$/.test(code);" "}" "" "module.exports = { isValidCoupon };"

# 4) Untracked junk -> delete it
write scratch.txt "random notes from debugging"
write src/cart.js.orig "// leftover from an old merge"
write tmp/session-1.json '{"cart":[]}'
write tmp/session-2.json '{"cart":[{"id":7}]}'
write coverage/index.html "<html><body>Coverage 61%</body></html>"
