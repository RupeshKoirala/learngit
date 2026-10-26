# 052 — git blame like a detective.
# Story: a line's "last author" is hidden behind a move, a re-indent and a mass reformat.

# style helpers: the codebase starts with 4-space indents, single quotes and no semicolons
reindent_2() { perl -pi -e 's/^((?:    )+)/"  " x (length($1)\/4)/e' "$@"; }
prettier() {   # double quotes + semicolons, the way a formatter would
  perl -pi -e '
    s/'"'"'/"/g;
    if (/\S/ && !/^\s*\/\// && !/[{};,]\s*$/) { s/\s*$/;\n/ }
    elsif (/^module\.exports/ && !/;\s*$/) { s/\s*$/;\n/ }
  ' "$@"
}

new_repo repo
write README.md "# Brightcart storefront" "" "Tiny demo shop used for Git practice."
write src/cart.js \
  "// Shopping cart" \
  "function addItem(cart, item) {" \
  "    cart.items.push(item)" \
  "    return cart" \
  "}" \
  "" \
  "function total(cart) {" \
  "    return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0)" \
  "}" \
  "" \
  "module.exports = { addItem, total }"
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "    return '\$' + (cents / 100).toFixed(2)" \
  "}" \
  "" \
  "module.exports = { formatPrice }"
as maya; commit "Initial storefront"

as dev
write src/cart.js \
  "// Shopping cart" \
  "function addItem(cart, item) {" \
  "    cart.items.push(item)" \
  "    return cart" \
  "}" \
  "" \
  "function total(cart) {" \
  "    return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0)" \
  "}" \
  "" \
  "// Shipping: free above the threshold, flat rate otherwise" \
  "const FREE_SHIPPING_THRESHOLD = 3500" \
  "" \
  "function shippingFor(cart) {" \
  "    if (total(cart) >= FREE_SHIPPING_THRESHOLD) return 0" \
  "    return 499" \
  "}" \
  "" \
  "module.exports = { addItem, total, shippingFor }"
commit "Add flat-rate shipping, free over \$35"

as lena
replace src/cart.js "    return 499" "    return cart.express ? 1499 : 499"
commit "$(printf '%s\n\n%s' "Add express shipping option" "Express is a flat \$14.99, agreed with ops in #shipping.")"
remember express

as jo
replace src/cart.js "\n\/\/ Shipping:" "\nfunction removeItem(cart, id) {\n    cart.items = cart.items.filter(i => i.id !== id)\n    return cart\n}\n\n\/\/ Shipping:"
replace src/cart.js "addItem, total, shippingFor" "addItem, removeItem, total, shippingFor"
commit "Add removeItem to cart"

as dev
replace src/price.js "return '\\\$' \+ \(cents \/ 100\)\.toFixed\(2\)" "return 'USD ' + (cents \/ 100).toFixed(2)"
commit "Show prices with currency code"

as maya
write src/cart.js \
  "// Shopping cart" \
  "function addItem(cart, item) {" \
  "    cart.items.push(item)" \
  "    return cart" \
  "}" \
  "" \
  "function total(cart) {" \
  "    return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0)" \
  "}" \
  "" \
  "function removeItem(cart, id) {" \
  "    cart.items = cart.items.filter(i => i.id !== id)" \
  "    return cart" \
  "}" \
  "" \
  "module.exports = { addItem, removeItem, total }"
write src/shipping.js \
  "// Shipping rules" \
  "const { total } = require('./cart')" \
  "" \
  "// Shipping: free above the threshold, flat rate otherwise" \
  "const FREE_SHIPPING_THRESHOLD = 3500" \
  "" \
  "function shippingFor(cart) {" \
  "    if (total(cart) >= FREE_SHIPPING_THRESHOLD) return 0" \
  "    return cart.express ? 1499 : 499" \
  "}" \
  "" \
  "module.exports = { shippingFor }"
commit "Extract shipping rules into src/shipping.js"

as lena
append README.md "" "Shipping is free above a threshold; express costs extra."
commit "Document shipping in README"

as dev
replace src/shipping.js "= 3500" "= 5000"
commit "$(printf '%s\n\n%s\n\n%s' "Raise free-shipping threshold to \$50" "Sam asked for this as part of the Q3 margin plan; finance signed off." "Refs: PRICING-88")"
remember threshold

as jo
reindent_2 src/cart.js src/price.js src/shipping.js
commit "Use 2-space indentation everywhere"

as maya
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  return 'USD ' + (cents / 100).toFixed(2)" \
  "}" \
  "" \
  "function formatDiscount(pct) {" \
  "  return pct + '% off'" \
  "}" \
  "" \
  "module.exports = { formatPrice, formatDiscount }"
commit "Add formatDiscount helper"

as bot
prettier src/cart.js src/price.js src/shipping.js
commit "$(printf '%s\n\n%s' "Format all code with prettier" "Automated: npx prettier --write src/ (no behaviour change)")"
remember prettier

as lena
write tests/shipping.test.sh "#!/bin/sh" "# TODO: real tests for shippingFor" "echo 'shipping tests: 0 run'"
commit "Add placeholder shipping tests"
as maya
append README.md "" "Questions about shipping rules? Ask in #shipping."
commit "Point README readers to #shipping"
remember tip
