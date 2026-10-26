# Lena moved src/price.js to src/utils/money.js AND grew it (similarity < 50 %), while you edited src/price.js.
new_repo repo
brightcart_skeleton
write src/price.js \
  "// Price formatting" \
  "const CURRENCY = '\$';" \
  "" \
  "function formatPrice(cents) {" \
  "  const sign = cents < 0 ? '-' : '';" \
  "  const abs = Math.abs(cents);" \
  "  return sign + CURRENCY + (abs / 100).toFixed(2);" \
  "}" \
  "" \
  "function formatRange(lo, hi) {" \
  "  return formatPrice(lo) + ' - ' + formatPrice(hi);" \
  "}" \
  "" \
  "exports.formatPrice = formatPrice;" \
  "exports.formatRange = formatRange;"
write src/checkout.js "// Checkout" "const { formatPrice } = require('./price');" "module.exports = { show: (c) => formatPrice(c) };"
as maya; commit "Initial storefront"

# --- your branch: edit price.js, add a file that requires it ---------------------------------------------
git switch -q -c feature/sale-prices
as you
append src/price.js "" \
  "function formatSalePrice(cents, percentOff) {" \
  "  const sale = Math.round(cents * (100 - percentOff) / 100);" \
  "  return formatPrice(sale) + ' (was ' + formatPrice(cents) + ')';" \
  "}" \
  "exports.formatSalePrice = formatSalePrice;"
commit "Add formatSalePrice"
write src/sale-banner.js "// Sale banner" "const { formatSalePrice } = require('./price');" \
  "function banner(p) { return 'SALE ' + formatSalePrice(p.cents, p.off); }" "module.exports = { banner };"
commit "Add sale banner"

# --- meanwhile Lena reorganises main --------------------------------------------------------------------
git switch -q main
as lena
mkdir -p src/utils
git mv src/price.js src/utils/money.js
{ printf '%s\n' \
  "// Money helpers. All amounts are integer cents, never floats." \
  "// Moved from src/price.js, see docs/adr/007-utils-folder.md." \
  "" \
  "function parseMoney(text) {" \
  "  const [whole, frac = ''] = String(text).replace(/[\$,]/g, '').split('.');" \
  "  return parseInt(whole, 10) * 100 + parseInt((frac + '00').slice(0, 2), 10);" \
  "}" \
  "exports.parseMoney = parseMoney;" \
  "" \
  "function toCents(dollars) {" \
  "  return Math.round(dollars * 100);" \
  "}" \
  "exports.toCents = toCents;" \
  ""; cat src/utils/money.js; } > src/utils/money.tmp
mv src/utils/money.tmp src/utils/money.js
replace src/checkout.js "require\('.\/price'\)" "require('.\/utils\/money')"
commit "Move price helpers to src/utils/money.js, add parseMoney"
as you
remember main
git switch -q feature/sale-prices
remember mine
