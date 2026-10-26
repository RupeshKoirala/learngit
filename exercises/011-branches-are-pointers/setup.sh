new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
git tag -a v1.0 -m "Brightcart 1.0"
git branch release/1.0

write src/shipping.js "// Shipping rules" "const FREE_SHIPPING_THRESHOLD = 5000; // cents" "" \
  "function shippingCost(totalCents) {" "  if (totalCents >= FREE_SHIPPING_THRESHOLD) return 0;" "  return 499;" "}" "" \
  "module.exports = { shippingCost };"
append README.md "" "Free shiping on orders over \$50."
commit "Add free-shipping threshold"
as lena
write src/price.js "// Price formatting" "function formatPrice(cents, currency) {" \
  "  return (currency || 'USD') + ' ' + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Show prices with currency code"
write src/search.js "// Product search" "function search(products, q) {" \
  "  q = q.toLowerCase();" "  return products.filter(p => p.name.toLowerCase().includes(q));" "}" "" "module.exports = { search };"
commit "Add product search box"

# a badly named branch someone (you) made last week
git switch -q -c fixtypo
as you
replace README.md "shiping" "shipping"
commit "Fix typo in README"
git switch -q main

git remote add origin ../remotes/origin.git
git push -q -u origin main release/1.0 2>/dev/null

# meanwhile Maya pushes a hotfix to release/1.0; you have fetched it but not pulled
git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/.team/maya"
cd "$LG_DIR/.team/maya"
git switch -q release/1.0
as maya
replace src/cart.js "i\.price \* i\.qty, 0\)" "Math.round(i.price * i.qty), 0)"
commit "Hotfix: round line totals to whole cents"
git push -q origin release/1.0 2>/dev/null
cd "$LG_DIR/repo"
git fetch -q
as you

remember main main
remember fixtypo fixtypo
