new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/reviews
as you
write src/reviews.js "// Product reviews" "function addReview(product, stars, text) {" "  product.reviews = product.reviews || [];" "  product.reviews.push({ stars, text });" "  return product;" "}" "" "module.exports = { addReview };"
commit "Add product reviews model"
# One commit that does two unrelated things: a new widget AND a bug fix in price.js.
write src/rating.js "// Star rating widget" "function stars(avg) {" "  const full = Math.round(avg);" "  return '★'.repeat(full) + '☆'.repeat(5 - full);" "}" "" "function average(reviews) {" "  if (!reviews.length) return 0;" "  return reviews.reduce((s, r) => s + r.stars, 0) / reviews.length;" "}" "" "module.exports = { stars, average };"
write src/price.js "// Price formatting" "function formatPrice(cents) {" "  // cents can be fractional after percentage discounts: round before formatting" "  return '\$' + (Math.round(cents) / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
commit "Add star rating widget + fix price rounding"
write src/product-page.js "// Product page" "const { stars, average } = require('./rating');" "" "function ratingLine(product) {" "  return stars(average(product.reviews || []));" "}" "" "module.exports = { ratingLine };"
commit "Show average rating on product page"
remember original
