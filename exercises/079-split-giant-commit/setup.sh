# One giant "do everything" commit on feature/checkout-revamp: tax + shipping + UI + docs.
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) { cart.items = cart.items.filter(i => i.id !== id); return cart; }"
         commit "Add removeItem to cart"
remember main

git switch -q -c feature/checkout-revamp
as you
# --- tax (≈600 lines) ---
perl -e 'print "// Sales-tax rates by region (generated from the 2025 rate sheet)\nmodule.exports = {\n";
         for my $i (1..600) { printf "  \"R%04d\": %.4f,\n", $i, (($i * 37) % 250) / 1000 } print "};\n"' > src/tax-rates.js
write src/tax.js "// Sales tax" "const rates = require('./tax-rates');" "" \
  "function taxFor(totalCents, region) {" "  const rate = rates[region] || 0;" "  return Math.round(totalCents * rate);" "}" "" "module.exports = { taxFor };"
# --- shipping (≈500 lines) ---
perl -e 'print "// Shipping zones by postcode prefix (generated)\nmodule.exports = {\n";
         for my $i (1..500) { printf "  \"%03d\": { zone: %d, days: %d },\n", $i, $i % 7 + 1, $i % 5 + 2 } print "};\n"' > src/shipping-zones.js
write src/shipping.js "// Shipping cost" "const zones = require('./shipping-zones');" "" \
  "function shippingFor(postcode, weightGrams) {" "  const z = zones[postcode.slice(0, 3)] || { zone: 7 };" \
  "  return 299 + z.zone * 100 + Math.ceil(weightGrams / 500) * 50;" "}" "" "module.exports = { shippingFor };"
# --- checkout summary UI (≈350 lines) ---
{ echo "// Checkout summary UI"
  echo "const { taxFor } = require('./tax');"
  echo "const { shippingFor } = require('./shipping');"
  echo "const { formatPrice } = require('./price');"
  echo ""
  echo "function summary(cart, address) {"
  echo "  const sub = cart.items.reduce((s, i) => s + i.price * i.qty, 0);"
  echo "  const tax = taxFor(sub, address.region);"
  echo "  const ship = shippingFor(address.postcode, cart.weight || 0);"
  echo "  return { sub: formatPrice(sub), tax: formatPrice(tax), ship: formatPrice(ship), total: formatPrice(sub + tax + ship) };"
  echo "}"
  echo ""
  echo "const labels = {"
  perl -e 'for my $i (1..330) { printf "  label%03d: \"Checkout text %03d\",\n", $i, $i }'
  echo "};"
  echo ""
  echo "module.exports = { summary, labels };"
} > src/checkout-ui.js
replace src/cart.js "module.exports = \{ addItem, total \};" "module.exports = { addItem, total, removeItem };"
append README.md "" "## Checkout" "" "The summary shows subtotal, tax (by region) and shipping (by postcode)."
commit "Checkout revamp: tax, shipping, summary UI, docs"
remember big
