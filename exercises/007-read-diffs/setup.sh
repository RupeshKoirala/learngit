new_repo repo
brightcart_skeleton
append README.md "" "## Shipping" "" "Orders over \$50 ship free within the continental US; everything else ships at a flat rate of \$4.99, and express shipping can be added at checkout for an extra \$12."
as maya; commit "Initial storefront"
git tag v1.0

as dev
replace src/cart.js "function total\(cart\) \{\n  return cart.items.reduce\(\(sum, i\) => sum \+ i.price \* i.qty, 0\);\n\}" \
  "function total(cart) {\n  const subtotal = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);\n  return subtotal - (cart.discount || 0);\n}"
commit "Support cart-level discounts in total"
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}" "" "function isEmpty(cart) {" "  return cart.items.length === 0;" "}"
commit "Add removeItem and isEmpty"
git tag v1.1
mkdir -p "$LG_DIR/.lg"
git diff --numstat v1.0 v1.1 -- src/cart.js | cut -f1 > "$LG_DIR/.lg/q4"

# Lena's gift-card branch: touches 3 files.
as lena
git switch -q -c feature/gift-cards
write src/giftcard.js "// Gift cards" "function redeem(cart, card) {" "  cart.discount = (cart.discount || 0) + card.balance;" "  return cart;" "}" "" "module.exports = { redeem };"
commit "Add gift card redemption"
replace src/cart.js "\/\/ Shopping cart" "\/\/ Shopping cart (gift cards: see giftcard.js)"
commit "Point cart to gift cards"
append README.md "" "Gift cards can be redeemed at checkout."
commit "Document gift cards"

# Meanwhile main moved on with unrelated work.
git switch -q main
as dev
replace src/price.js "function formatPrice\(cents\)" "function formatPrice(cents, currency)"
append test.sh "# TODO: run price tests"
commit "Prepare formatPrice for currencies"
remember main_tip main
remember gift_tip feature/gift-cards

# Your uncommitted work on main:
as you
replace src/cart.js "\/\/ Shopping cart" "\/\/ Shopping cart — v2"
replace src/price.js "\/\/ Price formatting" "\/\/ Price formatting (cents -> display string)"
git add src/cart.js src/price.js
replace src/price.js "toFixed\(2\)" "toFixed(2).replace('.', ',')"
replace README.md "continental" "contiguous"
git diff         | git hash-object --stdin > "$LG_DIR/.lg/unstaged"
git diff --staged | git hash-object --stdin > "$LG_DIR/.lg/staged"

printf '%s\n' "q1=" "q2=" "q3=" "q4=" > "$LG_DIR/ANSWER"
