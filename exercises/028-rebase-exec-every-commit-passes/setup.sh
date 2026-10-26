new_repo repo
brightcart_skeleton
# A slightly stricter fake test suite for this exercise (no Node needed).
write test.sh "#!/bin/sh" "# Fake test suite: checks what our real unit tests would catch." \
  "if grep -rq 'BUG' src; then echo 'tests FAILED: bug marker in src/'; exit 1; fi" \
  "for f in src/*.js; do" \
  "  if ! grep -q 'module.exports' \"\$f\"; then echo \"tests FAILED: \$f exports nothing, require() returns {}\"; exit 1; fi" \
  "done" \
  "echo 'tests passed'"
chmod +x test.sh
as maya; commit "Initial storefront"

git switch -q -c feature/loyalty
as you
write src/tiers.js "// Loyalty tiers" "const TIERS = ['bronze', 'silver', 'gold'];" "" "function tierFor(points) {" "  return points >= 1000 ? 'gold' : points >= 250 ? 'silver' : 'bronze';" "}" "" "module.exports = { TIERS, tierFor };"
commit "Add loyalty tier names"
write src/loyalty.js "// Loyalty points: 1 point per whole dollar spent" "function pointsFor(totalCents) {" "  return Math.floor(totalCents / 100);" "}" "" "function addPoints(customer, totalCents) {" "  customer.points = (customer.points || 0) + pointsFor(totalCents);" "  return customer;" "}"
commit "Add loyalty points calculator"
remember broken
write src/checkout.js "// Checkout" "const { addPoints } = require('./loyalty');" "" "function completeOrder(customer, order) {" "  addPoints(customer, order.totalCents);" "  order.status = 'paid';" "  return order;" "}" "" "module.exports = { completeOrder };"
commit "Award loyalty points at checkout"
append src/loyalty.js "" "module.exports = { pointsFor, addPoints };"
commit "Export loyalty helpers"
remember original
