new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
git remote add origin ../remotes/origin.git
git push -q -u origin main 2>/dev/null

# you forgot to create a branch...
as you
write src/wishlist.js "// Wishlist store" "function addToWishlist(list, productId) {" \
  "  if (!list.includes(productId)) list.push(productId);" "  return list;" "}" "" "module.exports = { addToWishlist };"
commit "Add wishlist store"
write src/api/wishlist.js "// GET/POST /api/wishlist" "const { addToWishlist } = require('../wishlist');" "" \
  "function handle(req, list) {" "  if (req.method === 'POST') return addToWishlist(list, req.body.productId);" "  return list;" "}" "" \
  "module.exports = { handle };"
commit "Add wishlist API route"
write tests/wishlist.test.sh "#!/bin/sh" "# wishlist: adding twice keeps one entry" "echo 'wishlist tests passed'"
commit "Add wishlist tests"
remember wishlist main

# ...and you're in the middle of the next change (not committed yet)
replace src/wishlist.js "module\.exports = \{ addToWishlist \};" \
  "function removeFromWishlist(list, productId) {\n  return list.filter(id => id !== productId);\n}\n\nmodule.exports = { addToWishlist, removeFromWishlist };"

# meanwhile Dev pushed a fix to main (you haven't fetched yet)
git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/.team/dev"
cd "$LG_DIR/.team/dev"
as dev
replace src/price.js "\(cents \/ 100\)" "(Math.round(cents) \/ 100)"
commit "Round fractional cents in formatPrice"
git push -q origin main 2>/dev/null
remember remote_main main
cd "$LG_DIR/repo"
as you
