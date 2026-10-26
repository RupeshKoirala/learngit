new_repo repo
brightcart_skeleton
write scripts/seed.js \
  "// Seed the dev database with demo products (CLI script: printing is its job)" \
  "const products = [" \
  "  { id: 1, name: 'Mug', price: 1200 }," \
  "  { id: 2, name: 'Tote bag', price: 1800 }," \
  "];" \
  "" \
  "console.log('Seeding', products.length, 'products');" \
  "console.log('TODO: connect to the real database');" \
  "module.exports = { products };"
as maya; commit "chore: initial storefront"
as lena; append src/price.js "" "function formatDiscount(pct) {" "  return pct + '% off';" "}"
         commit "feat(price): add formatDiscount helper"
day
as dev;  write src/payments.js "// Payments" "const STRIPE_KEY = process.env.STRIPE_KEY;" "" "function charge(cents) {" "  return { ok: true, cents };" "}" "" "module.exports = { charge };"
         commit "feat(checkout): add payment client"
as dev;  write docs/incident-2025-01.md \
  "# Incident: live Stripe key pushed to the repo" "" \
  "A live key was hard-coded in src/payments.js for 40 minutes before it was noticed." \
  "The key was rotated. Action item (Maya): add shared Git hooks so this cannot happen again."
         commit "docs: write up the leaked-key incident"
as maya; append README.md "" "Commit messages follow Conventional Commits: https://www.conventionalcommits.org"
         commit "docs: adopt Conventional Commits"
as you
