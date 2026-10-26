new_repo repo
brightcart_skeleton
write src/checkout.js \
  "// Checkout" \
  "function shippingFor(cart) {" \
  "  return cart.items[0].weight > 5000 ? 900 : 499;" \
  "}" \
  "" \
  "module.exports = { shippingFor };"
as maya; commit "Initial storefront"
as dev;  replace src/checkout.js "function shippingFor" "\/\/ BUG: crashes when the cart is empty (items[0] is undefined) - INC-2041\nfunction shippingFor"
         commit "Ship faster checkout"
remember main

git switch -q -c feature/reviews
as you
write src/reviews.js "// Product reviews" "function addReview(product, stars, text) {" "  product.reviews.push({ stars, text });" "}" "" "module.exports = { addReview };"
commit "Add review model"
remember head

# half-done work in three states: staged, unstaged, untracked
append README.md "" "Reviews: customers can rate products 1-5 stars."
git add README.md
replace src/reviews.js "  product\.reviews\.push\(\{ stars, text \}\);" "  if (stars < 1 || stars > 5) throw new Error('stars must be 1-5');\n  product.reviews.push({ stars, text, at: Date.now() });\n  \/\/ TODO: average rating cache"
write src/reviews-ui.js "// Star widget (untracked, very WIP)" "function stars(n) { return '★'.repeat(n) + '☆'.repeat(5 - n); }"
git diff          | git hash-object --stdin > "$LG_DIR/.lg/unstaged"
git diff --cached | git hash-object --stdin > "$LG_DIR/.lg/staged"
git hash-object src/reviews-ui.js > "$LG_DIR/.lg/untracked"
