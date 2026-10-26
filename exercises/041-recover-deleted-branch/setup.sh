keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_repo repo
keep_everything
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

as you
git switch -q -c feature/wishlist
write src/wishlist.js "// Wishlist" "function addToWishlist(list, productId) {" "  list.push(productId);" "  return list;" "}" "" "module.exports = { addToWishlist };"
commit "Add wishlist model"
write src/wishlist.js "// Wishlist" "function addToWishlist(list, productId) {" "  if (!list.includes(productId)) list.push(productId);" "  return list;" "}" "" \
  "function removeFromWishlist(list, productId) {" "  return list.filter(id => id !== productId);" "}" "" "module.exports = { addToWishlist, removeFromWishlist };"
commit "Add removeFromWishlist and avoid duplicates"
append README.md "" "Wishlist: logged-in users can save products for later."
commit "Document the wishlist"
remember wishlist

# Back to main for some other work…
git switch -q main
append src/price.js "" "// TODO: support other currencies"
commit "Add currency TODO"
# …a quick throwaway spike…
git switch -q -c spike/try-new-router
write src/router.js "// spike" "module.exports = {};"
commit "Spike: new router"
git switch -q main
git branch -q -D spike/try-new-router
# …and then a cleanup spree that went one branch too far
git switch -q -c feature/old-banner
git switch -q main
git branch -q -D feature/old-banner
git branch -q -D feature/wishlist
remember main main
