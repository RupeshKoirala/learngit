# A .env file with a live API key was committed 8 commits ago and pushed (main, a feature branch and a tag).
OLD_KEY=pfx_live_9f3c2a7e5b1d4c88a01e

new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
write .gitignore "node_modules/" "*.log"
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git
git push -q -u origin main

# --- the accident: .env goes in together with real code -------------------------------------------
day; as you
write src/payments.js \
  "// PayFlux payment client" \
  "const secret = process.env.PAYFLUX_SECRET;" \
  "" \
  "function charge(order) {" \
  "  if (!secret) throw new Error('PAYFLUX_SECRET is not set');" \
  "  return { ok: true, amount: order.total };" \
  "}" \
  "" \
  "module.exports = { charge };"
write .env "PAYFLUX_SECRET=$OLD_KEY" "PAYFLUX_ENV=live"
commit "Add PayFlux payment client"                                                     # main~8

as dev;  append src/cart.js "" "function clear(cart) { cart.items = []; return cart; }"; commit "Add clear() to cart"
as you;  append .env "ORDERS_DB_URL=postgres://orders:hunter2@db.internal/orders"
         append src/payments.js "// orders are persisted via ORDERS_DB_URL"; commit "Connect payments to orders DB"
as lena; write src/checkout.js "// Checkout page" "const { charge } = require('./payments');" "module.exports = { charge };"
         commit "Add checkout page"
as maya; append README.md "" "Payments: PayFlux (see src/payments.js)."; commit "Document payments"
git tag -a v0.9 -m "Beta release"
as dev;  replace src/price.js "toFixed\(2\)" "toFixed(2).replace('.00', '')"; commit "Hide .00 on round prices"
as lena; append src/checkout.js "// TODO: address form"; commit "Stub address form"
as you;  append src/payments.js "// retries: 3"; commit "Retry failed charges"
as maya; append README.md "" "Run ./test.sh before pushing."; commit "Mention tests in README"   # main (8 after the leak)

git switch -q -c feature/refunds
as dev;  write src/refunds.js "// Refunds" "function refund(id) { return { id: id, ok: true }; }" "module.exports = { refund };"
         commit "Add refunds module"
         append src/refunds.js "// partial refunds later"; commit "Note partial refunds"
git switch -q main
git push -q origin main feature/refunds v0.9
as you

# Maya already has a clone with the leaked history (that's why everyone must re-clone afterwards).
git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/.team/maya"

mkdir -p "$LG_DIR/.lg"
git rev-list --count main > "$LG_DIR/.lg/main.count"
