new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/wishlist
as you
write src/wishlist.js "// Wishlist: products a shopper saved for later" "function addToWishlist(list, productId) {" "  if (!list.includes(productId)) list.push(productId);" "  return list;" "}" "" "module.exports = { addToWishlist };"
commit "asdf"
append README.md "" "Wishlist: tap the heart on any product to save it for later."
commit "Document the wishlist"
write src/debug.js "// TEMP: dump the wishlist on every request. DO NOT SHIP." "module.exports = (list) => console.log('WISHLIST', JSON.stringify(list));"
commit "temp debug"
write src/product-page.js "// Product page" "const { addToWishlist } = require('./wishlist');" "" "function onHeartClick(session, product) {" "  addToWishlist(session.wishlist, product.id);" "}" "" "module.exports = { onHeartClick };"
commit "add btn"
remember original
