new_repo repo
brightcart_skeleton
as maya; commit "chore: initial storefront"

git switch -q -c feature/multi-currency
as you
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents, currency) {" \
  "  const symbols = { USD: '\$', EUR: 'EUR ', GBP: 'GBP ' };" \
  "  return (symbols[currency] || '\$') + (cents / 100).toFixed(2);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
commit "feat(price): accept a currency code"
replace src/cart.js "module.exports = \{ addItem, total \};" "function totalIn(cart, currency) {\n  return { cents: total(cart), currency };\n}\n\nmodule.exports = { addItem, total, totalIn };"
commit "feat(cart): add totalIn for multi-currency carts"
append README.md "" "Prices can be shown in USD, EUR or GBP."
commit "docs: mention multi-currency prices"

git switch -q main
as maya
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(cents / 100);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
commit "refactor(price): use Intl.NumberFormat"
as dev; replace src/cart.js "\/\/ Shopping cart" "\/\/ Shopping cart\n\/\/ TODO: tax per region"
commit "chore(cart): note regional tax todo"
remember main
git switch -q feature/multi-currency
as you
