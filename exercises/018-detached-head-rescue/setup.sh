coupons_js() {   # coupons_js <comparison operator>
  write src/coupons.js "// Coupon validation" "function couponValid(coupon, now) {" \
    "  if (coupon.expires $1 now) return false;" "  return coupon.active;" "}" "" "module.exports = { couponValid };"
}

new_repo repo
brightcart_skeleton
coupons_js "<"
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
git tag -a v1.1 -m "Release 1.1"

# two weeks ago: a throwaway experiment on a detached HEAD (genuinely garbage)
as you
git switch -q --detach v1.1
append src/cart.js "console.log('cart changed', JSON.stringify(cart));"
commit "debug: log every cart change"
git switch -q main 2>/dev/null

as lena
write src/wishlist.js "// Wishlist" "function addToWishlist(list, id) {" "  if (!list.includes(id)) list.push(id);" "  return list;" "}" "" \
  "module.exports = { addToWishlist };"
commit "Add wishlist"
as bot
git tag -a v1.2 -m "Release 1.2"
as maya
write src/checkout.js "// Checkout v2 (redesign in progress)" "module.exports = {};"
commit "Start checkout redesign"
append src/checkout.js "// express shipping option goes here"
commit "Add express shipping option placeholder"
remember main main

# this morning: reproduce a customer bug on the released version
as you
git switch -q --detach v1.2
write tests/coupons.test.sh "#!/bin/sh" "# A coupon that expires exactly now must be rejected" \
  "grep -q 'expires <= now' src/coupons.js || { echo 'coupon expiry test FAILED'; exit 1; }" "echo 'coupon tests passed'"
chmod +x tests/coupons.test.sh
commit "Add failing test for coupon expiry"
coupons_js "<="
commit "Fix coupon expiry off-by-one"
remember rescued

# ...then got pulled into a meeting and switched away
git switch -q main 2>/dev/null
git switch -q -c chore/bump-deps
append README.md "" "Requires Node 20."
commit "Document Node 20 requirement"
git switch -q main
