new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
remember main main

# Monday: you start the wishlist ticket
as you
git switch -q -c feature/wishlist
write src/wishlist.js "// Wishlist store" "function addToWishlist(list, productId) {" \
  "  if (!list.includes(productId)) list.push(productId);" "  return list;" "}" "" "module.exports = { addToWishlist };"
commit "Add wishlist store"
remember wishlist feature/wishlist

# Tuesday: urgent search ticket, new branch from main
git switch -q main
git switch -q -c feature/search-filters
write src/search.js "// Product search filters" "function byPrice(products, min, max) {" \
  "  return products.filter(p => p.price >= min && p.price <= max);" "}" "" "module.exports = { byPrice };"
commit "Add price range filter"
replace src/search.js "module\.exports = \{ byPrice \};" \
  "function byBrand(products, brand) {\n  return products.filter(p => p.brand === brand);\n}\n\nmodule.exports = { byPrice, byBrand };"
commit "Add brand filter"
remember search feature/search-filters

# Wednesday: back to wishlist work... but you never switched branches
write src/wishlist-button.js "// Heart button on product cards" "function heartButton(productId, inList) {" \
  "  return '<button data-id=\"' + productId + '\">' + (inList ? '♥' : '♡') + '</button>';" "}" "" \
  "module.exports = { heartButton };"
commit "Add wishlist heart button"
write src/wishlist-button.js "// Heart button on product cards" "function heartButton(productId, inList) {" \
  "  return '<button data-id=\"' + productId + '\">' + (inList ? '♥' : '♡') + '</button>';" "}" "" \
  "function countBadge(list) {" "  return list.length ? '<span class=\"badge\">' + list.length + '</span>' : '';" "}" "" \
  "module.exports = { heartButton, countBadge };"
commit "Show wishlist count badge"
remember wrong feature/search-filters
