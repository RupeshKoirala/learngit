new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
as bot; git tag -a v1.2.0 -m "Release 1.2.0"

day
as dev
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents, currency) {" \
  "  return new Intl.NumberFormat('en-US', { style: 'currency', currency: currency || 'USD' }).format(cents / 100);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
commit "Format prices with Intl.NumberFormat"
as lena
append src/cart.js "" "function itemCount(cart) {" "  return cart.items.reduce((n, i) => n + i.qty, 0);" "}"
commit "Add itemCount to cart"
as dev
replace src/price.js "currency \|\| 'USD'" "currency || process.env.CURRENCY"
commit "Read default currency from env"
as maya
append README.md "" "Changelog: see CHANGELOG.md"
commit "Mention the changelog"
as bot; git tag -a v1.3.0 -m "Release 1.3.0"
as you
remember main

# Your own unfinished work in progress (not committed)
append src/cart.js "" "// WIP: bulk discount for qty >= 10" "function bulkDiscount(cart) { return 0; }"
