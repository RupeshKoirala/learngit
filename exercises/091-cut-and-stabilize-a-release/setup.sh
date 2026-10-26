new_bare "$LG_DIR/remotes/origin.git"
new_repo repo
git remote add origin ../remotes/origin.git

brightcart_skeleton
write VERSION "1.9.0"
write test.sh "#!/bin/sh" "# Brightcart release smoke tests (QA's checklist, automated)" "fail=0" \
  "grep -q 'TAX_RATE = 0.08;' src/checkout.js || { echo 'FAIL BC-201: tax must be 8%'; fail=1; }" \
  "grep -q 'toFixed(2)' src/price.js || { echo 'FAIL BC-202: prices need 2 decimals'; fail=1; }" \
  "[ \$fail = 0 ] && echo 'tests passed'" "exit \$fail"
chmod +x test.sh
as maya; commit "chore: initial storefront"
git tag -a v1.9.0 -m "Release 1.9.0"

day 3
as dev
write src/checkout.js \
  "// Checkout" \
  "const TAX_RATE = 0.8;" \
  "" \
  "function withTax(cents) {" \
  "  return Math.round(cents * (1 + TAX_RATE));" \
  "}" \
  "" \
  "module.exports = { withTax };"
commit "feat(checkout): add sales tax to order totals"
as lena
replace src/price.js "toFixed\(2\)" "toFixed(1)"
commit "feat(price): compact price labels"
as dev
append src/cart.js "" "function itemCount(cart) {" "  return cart.items.reduce((n, i) => n + i.qty, 0);" "}"
commit "feat(cart): show item count badge"
day 2
as maya
write VERSION "2.0.0"
commit "chore(release): code freeze for 2.0.0"
remember freeze

day 1
as dev
write src/giftwrap.js "// Gift wrapping (planned for 2.1)" "function wrapPrice() {" "  return 499;" "}" "" "module.exports = { wrapPrice };"
commit "feat(giftwrap): gift wrapping option"
remember giftwrap
as maya
write VERSION "2.1.0-dev"
commit "chore: open 2.1 development"
git push -q -u origin main v1.9.0
as you
