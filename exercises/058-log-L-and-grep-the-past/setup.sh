# 058 — git log -L for one function, git show --stat, git grep in a past revision.

# tax.js is rebuilt from parts so each commit can change exactly one function
HEADER="// Tax rules"; F_RATE=""; F_CALC=""; F_FMT=""; F_ROUND=""
emit() {
  {
    echo "$HEADER"; echo
    [ -n "$F_RATE" ]  && printf '%s\n\n' "$F_RATE"
    [ -n "$F_ROUND" ] && printf '%s\n\n' "$F_ROUND"
    printf '%s\n\n' "$F_CALC"
    [ -n "$F_FMT" ]   && printf '%s\n\n' "$F_FMT"
    echo "module.exports = { calculateTax };"
  } > src/tax.js
}
nl='
'

new_repo repo
brightcart_skeleton
write src/legacy/vat.js "// Old VAT helper, kept for the EU shop" "const TAX_RATE_EU = 0.21;" "module.exports = { TAX_RATE_EU };"
as maya; commit "Initial storefront"

as dev
F_CALC="function calculateTax(order) {${nl}  return order.subtotal * 0.2;${nl}}"
emit; commit "Add flat 20% tax"

as lena
F_FMT="function formatTax(cents) {${nl}  return 'Tax: ' + cents;${nl}}"
emit; commit "Show tax line on receipts"
git tag v1.0

as jo
write tests/tax.test.sh "#!/bin/sh" "echo 'tax tests: TODO'"; commit "Add tax test stub"

as dev
F_CALC="function calculateTax(order) {${nl}  const taxable = order.subtotal - (order.discount || 0);${nl}  return Math.round(taxable * 0.2);${nl}}"
emit; commit "Tax the discounted subtotal, not the full price"

as lena
F_FMT="function formatTax(cents) {${nl}  return 'VAT: ' + (cents / 100).toFixed(2);${nl}}"
emit; commit "Format tax in dollars"

as maya
F_RATE="function rateFor(region) {${nl}  return region === 'EU' ? 0.21 : 0.2;${nl}}"
git rm -q src/legacy/vat.js
emit; commit "Inline EU VAT rate into rateFor, drop legacy module"

as jo
append README.md "" "Tax is computed in src/tax.js."; commit "Mention tax module in README"

as dev
F_ROUND="function roundCents(x) {${nl}  return Math.round(x);${nl}}"
emit; commit "Add roundCents helper"

as dev
F_CALC="function calculateTax(order) {${nl}  const taxable = order.subtotal - (order.discount || 0);${nl}  return Math.floor(taxable * 0.2);${nl}}"
emit
append tests/tax.test.sh "# 999 cents -> 199 tax (floor), was 200"
append CHANGELOG.md "- Tax is now rounded down (finance request FIN-31)"
commit "$(printf '%s\n\n%s' "Round tax down instead of to nearest" "Finance wants to never over-charge tax by a cent (FIN-31).")"
remember rounding

as lena
F_FMT="function formatTax(cents) {${nl}  return 'VAT ' + (cents / 100).toFixed(2);${nl}}"
emit; commit "Drop colon from tax label"

as maya
F_CALC="function calculateTax(order) {${nl}  const taxable = order.subtotal - (order.discount || 0);${nl}  return Math.floor(taxable * rateFor(order.region));${nl}}"
emit; commit "Use per-region tax rate"

as jo
F_RATE="function rateFor(region) {${nl}  if (region === 'EU') return 0.21;${nl}  if (region === 'UK') return 0.2;${nl}  return 0.2;${nl}}"
emit; commit "Add UK tax rate"

as dev
append src/cart.js "// cart uses calculateTax at checkout"; commit "Note where tax is applied"
remember tip
