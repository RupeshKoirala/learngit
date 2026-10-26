new_bare "$LG_DIR/remotes/origin.git"
new_repo repo
git remote add origin ../remotes/origin.git

brightcart_skeleton
write VERSION "1.9.0"
write src/shipping.js \
  "// Shipping rules" \
  "const FREE_SHIPPING_FROM = 5000; // cents" \
  "" \
  "function shippingCost(totalCents) {" \
  "  if (totalCents > FREE_SHIPPING_FROM) return 0;" \
  "  return 599;" \
  "}" \
  "" \
  "// Carriers we hand parcels to" \
  "const CARRIERS = ['PostNord'];" \
  "" \
  "module.exports = { shippingCost, CARRIERS };"
write test.sh "#!/bin/sh" "# smoke tests" \
  "grep -q 'totalCents >= FREE_SHIPPING_FROM' src/shipping.js || { echo 'FAIL: orders of exactly \$50.00 must ship free'; exit 1; }" \
  "echo 'tests passed'"
chmod +x test.sh
as maya; commit "chore: initial storefront"
as dev
append src/cart.js "" "function itemCount(cart) {" "  return cart.items.reduce((n, i) => n + i.qty, 0);" "}"
commit "feat(cart): item count badge"
as maya
write VERSION "2.0.0"
commit "chore(release): 2.0.0"
git tag -a v2.0.0 -m "Brightcart 2.0.0"
remember v200 v2.0.0

day 2
as lena
write src/loyalty.js "// Loyalty points (unreleased, ships in 2.1)" "function pointsFor(cents) {" "  return Math.floor(cents / 100);" "}" "" "module.exports = { pointsFor };"
commit "feat(loyalty): earn points on every order"
remember loyalty
as maya
write VERSION "2.1.0-dev"
commit "chore: open 2.1 development"
as dev
replace src/shipping.js "\['PostNord'\]" "['PostNord', 'DHL', 'UPS']"
commit "feat(shipping): add DHL and UPS carriers"
remember devtip
git push -q -u origin main v2.0.0
as you
