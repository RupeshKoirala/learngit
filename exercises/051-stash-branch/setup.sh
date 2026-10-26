new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
write src/checkout.js \
  "// Checkout" \
  "const { total } = require('./cart');" \
  "" \
  "function checkout(cart) {" \
  "  const amount = total(cart);" \
  "  return { amount };" \
  "}" \
  "" \
  "module.exports = { checkout };"
commit "Add checkout"
remember base

# three weeks ago: you started loyalty points, then got pulled away
as you
replace src/checkout.js "  return \{ amount \};" "  const points = earnPoints(amount);\n  return { amount, points };"
replace src/checkout.js "const \{ total \} = require\('.\/cart'\);" "const { total } = require('.\/cart');\nconst { earnPoints } = require('.\/loyalty');"
write src/loyalty.js "// Loyalty points: 1 point per whole dollar" "function earnPoints(cents) {" "  return Math.floor(cents / 100);" "}" "" "module.exports = { earnPoints };"
git add src/loyalty.js
tick; git stash push -q -m "WIP: loyalty points in checkout"
remember loyalty stash@{0}

# meanwhile main moved on and checkout.js was rewritten
as lena
write src/checkout.js \
  "// Checkout, step by step" \
  "const { total } = require('./cart');" \
  "const { formatPrice } = require('./price');" \
  "" \
  "function checkout(cart) {" \
  "  const order = { amount: total(cart), currency: 'USD' };" \
  "  order.display = formatPrice(order.amount);" \
  "  return order;" \
  "}" \
  "" \
  "module.exports = { checkout };"
commit "Checkout: return a full order object"
as dev; write src/stock.js "// Stock levels" "function inStock(item) { return item.stock > 0; }" "module.exports = { inStock };"
        commit "Add stock check"
as you
write styles/dark.css "body { background: #111; }"
tick; git stash push -q -u -m "experiment: dark mode"
remember main
