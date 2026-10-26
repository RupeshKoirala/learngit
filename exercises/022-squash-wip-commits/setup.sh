new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"

git switch -q -c feature/discount-codes
as you
write src/discount.js "// Discount codes" "function applyCode(total, code) {" "  if (code === 'SAVE10') return total * 0.9;" "  return total;" "}"
commit "wip"
append src/discount.js "// TODO handle FREESHIP"
commit "wip 2"
write src/discount.js "// Discount codes" "function applyCode(total, code) {" "  if (code === 'SAVE10') return Math.round(total * 0.9);" "  return total;" "}" "" "module.exports = { applyCode };"
commit "fix rounding lol"
append README.md "" "Discount codes: SAVE10 takes 10% off."
commit "Document discount codes"
append src/discount.js "// console.log('debug', total)"
commit "oops forgot export? no. debug line"
replace src/discount.js "\n\/\/ console.log\('debug', total\)" ""
commit "remove debug"
remember original
