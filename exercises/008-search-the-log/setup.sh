# on_day N : set the fake clock to noon UTC, N days after 2025-01-01 (day 0 = Jan 1, day 60 = Mar 2)
on_day() { LG_CLOCK=$((1735689600 + $1 * 86400 + 43200)); tick 0; }
c() { git add -A; git commit -q -m "$1"; }   # commit at the current fake time

new_repo repo
brightcart_skeleton
write package.json '{ "name": "brightcart-storefront", "version": "1.40.0" }'
on_day 1;  as maya; c "Initial storefront"
on_day 3;  as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"; c "Add removeItem to cart"
on_day 6;  as lena; write src/cart.css ".cart { display: grid; gap: 8px; }"; c "Style the cart page"
remember lena_first
on_day 8;  as maya; write ci.sh "#!/bin/sh" "./test.sh"; c "Add CI script"
on_day 10; as dev;  write src/promo.js "// Promo codes" "const CODES = {" "  SAVE10: { percent: 10 }," "};" "" "module.exports = { CODES };"; c "Add promo codes"
on_day 13; as dev;  write src/tax.js "// Sales tax" "function taxFor(cents, region) {" "  return Math.round(cents * (region === 'NY' ? 0.08875 : 0.06));" "}" "" "module.exports = { taxFor };"
                    replace src/price.js "\/\/ Price formatting" "\/\/ Price formatting (tax lives in tax.js)"; c "Refactor pricing helpers"
remember tax_file
on_day 15; as lena; replace src/promo.js "  SAVE10: \{ percent: 10 \},\n" "  SAVE10: { percent: 10 },\n  FREESHIP50: { freeShippingOver: 5000 },\n"; c "Tweak promo config"
remember freeship
on_day 18; as lena; write src/cart.css ".cart { display: grid; gap: 12px; padding: 16px; }"; c "Polish cart page spacing"
on_day 20; as dev;  replace src/promo.js "SAVE10: \{ percent: 10 \}" "SAVE15: { percent: 15 }"; c "Tweak promo config"
on_day 24; as sam;  append README.md "" "## Roadmap" "" "- Gift cards" "- Saved carts"; c "Update README roadmap"
on_day 27; as dev;  write src/checkout.js "// Checkout" "function checkout(cart) {" "  if (!cart.coupon) return cart;" "  return cart;" "}" "module.exports = { checkout };"; c "Fix #24 coupon crash"
on_day 30; as dev;  replace src/checkout.js "  if \(!cart.coupon\) return cart;" "  if (!cart.coupon || !cart.coupon.code) return cart;"
                    c "$(printf '%s\n' "Handle edge case in checkout" "" "Customers pasting a coupon with trailing spaces sent an empty code" "object, which crashed the order summary." "" "Closes #42")"
remember issue42
on_day 34; as lena; write package.json '{ "name": "brightcart-storefront", "version": "1.42.0" }'; c "Bump version to 1.42"
on_day 40; as maya; replace src/tax.js ": 0.06\)" ": region === 'CA-ON' ? 0.13 : 0.06)"; c "Add tax rate for Canada"
on_day 55; as dev;  replace src/cart.js "\/\/ Shopping cart" "\/\/ Shopping cart (hot path, keep it fast)"; c "Speed up cart total"
on_day 60; as maya; replace src/checkout.js "function checkout\(cart\) \{" "function checkout(cart) {\n  if (!cart.items.length) throw new Error('empty cart');"; c "Guard against empty cart in checkout"
remember hotfix
on_day 68; as lena; replace src/promo.js "  FREESHIP50: \{ freeShippingOver: 5000 \},\n" ""; c "Clean up promo codes"
on_day 72; as jo;   replace README.md "Tiny demo shop" "A tiny demo shop"; c "Fix typo in README"
on_day 75; as dev;  replace src/tax.js "taxFor" "salesTaxFor"; c "Rename tax helper"
remember start
as you
