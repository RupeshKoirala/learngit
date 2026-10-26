# 053 — pickaxe: git log -S / -G with path filters.

filler() {   # filler <n>   n small, realistic commits on unrelated files
  _i=0
  while [ "$_i" -lt "$1" ]; do
    _k=$((LG_FILLER % 6)); LG_FILLER=$((LG_FILLER + 1))
    case $_k in
      0) as lena; append src/styles.css ".promo-$LG_FILLER { margin: ${LG_FILLER}px; }"; commit "Tweak promo banner spacing ($LG_FILLER)" ;;
      1) as dev;  append src/cart.js "// perf note $LG_FILLER: cache totals per request"; commit "Note cart performance idea #$LG_FILLER" ;;
      2) as maya; append CHANGELOG.md "- internal cleanup $LG_FILLER"; commit "Update changelog" ;;
      3) as jo;   append src/price.js "// rounding case $LG_FILLER covered by tests"; commit "Document price rounding edge case $LG_FILLER" ;;
      4) as lena; append src/styles.css ".btn-$LG_FILLER { border-radius: 4px; }"; commit "Add button variant $LG_FILLER" ;;
      5) as dev;  append config/flags.txt "experiment_$LG_FILLER=off"; commit "Add feature flag experiment_$LG_FILLER" ;;
    esac
    _i=$((_i + 1))
  done
}
LG_FILLER=1

new_repo repo
brightcart_skeleton
write CHANGELOG.md "# Changelog"
write src/styles.css "body { font-family: sans-serif; }"
write config/flags.txt "# feature flags"
as maya; commit "Initial storefront"

as dev
write src/discount.js \
  "// Coupons" \
  "function applyCoupon(total, code) {" \
  "  if (code === 'SAVE10') return Math.round(total * 0.9);" \
  "  return total;" \
  "}" \
  "" \
  "module.exports = { applyCoupon };"
commit "Add coupon support"
filler 2

as lena
write src/validate.js \
  "// Form validation" \
  "const EMAIL_RE = /^[a-z0-9._+-]+@[a-z0-9.-]+\\.[a-z]{2,}\$/;" \
  "" \
  "function isEmail(s) {" \
  "  return EMAIL_RE.test(s);" \
  "}" \
  "" \
  "module.exports = { EMAIL_RE, isEmail };"
commit "Add signup form validation"

as dev
write docs/api.md "# Internal API" "" "- \`applyCoupon(total, code)\` in src/discount.js" "- \`EMAIL_RE\` in src/validate.js: what we accept as an email"
commit "Document discount and validation helpers"

as jo
write src/checkout.js \
  "const { applyCoupon } = require('./discount');" \
  "" \
  "function checkout(cart, code) {" \
  "  return applyCoupon(cart.total, code);" \
  "}" \
  "" \
  "module.exports = { checkout };"
commit "Apply coupons at checkout"
filler 4

as maya
replace src/validate.js '\{2,\}\$\/;' '{2,}\$\/i;'
commit "Accept upper-case letters in emails"
filler 3

as lena
append docs/api.md "  Pattern: \`EMAIL_RE = /^[a-z0-9._+-]+@.../i\`, plus-addressing (anna+shop@...) is allowed."
commit "Explain EMAIL_RE in the API docs"
filler 3

as jo
replace src/validate.js '\[a-z0-9\._\+-\]\+@' '[a-z0-9._-]+@'
commit "$(printf '%s\n\n%s' "Tighten signup validation" "Reject odd characters that spam bots use in the local part.")"
remember regex
filler 4

as dev
write src/discount.js \
  "// Promo codes (formerly 'coupons')" \
  "function redeemCode(total, code) {" \
  "  if (code === 'SAVE10') return Math.round(total * 0.9);" \
  "  return total;" \
  "}" \
  "" \
  "module.exports = { redeemCode };"
write src/checkout.js \
  "const { redeemCode } = require('./discount');" \
  "" \
  "function checkout(cart, code) {" \
  "  return redeemCode(cart.total, code);" \
  "}" \
  "" \
  "module.exports = { checkout };"
commit "$(printf '%s\n\n%s' "Rename coupons to promo codes" "Marketing calls them promo codes everywhere now; keep the code consistent.")"
remember removed
filler 3

as maya
replace docs/api.md 'applyCoupon\(total, code\)' 'redeemCode(total, code)'
commit "Refresh API docs"
filler 4
remember tip
