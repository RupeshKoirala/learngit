R="$LG_DIR/remotes/origin.git"
new_bare "$R"

# Maya creates the team repository and pushes it to "GitHub" (the bare repo).
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin "$R"
git push -q -u origin main
as dev
write src/shipping.js "// Shipping costs" "function shippingCost(total) {" "  return 599;" "}" "" "module.exports = { shippingCost };"
commit "Add shipping cost calculator"
git push -q

# A week ago you cloned the repo on your laptop.
day 1
cd "$LG_DIR"
git clone -q "$R" repo
git -C repo config user.name "$LG_LEARNER_NAME"
git -C repo config user.email "$LG_LEARNER_EMAIL"

# While you were on holiday, the team kept pushing.
cd "$LG_DIR/.team/maya"
day 7
as lena; replace src/price.js "'\\\$' \+" "'USD ' +"; commit "Show prices with currency code"
as dev;  write src/shipping.js "// Shipping costs" "function shippingCost(total) {" "  return total >= 5000 ? 0 : 599;" "}" "" "module.exports = { shippingCost };"
         commit "Free shipping on orders over 50 dollars"
as maya; write CONTRIBUTING.md "# Contributing" "" "Branch from main, open a PR, get one approval."
         commit "Add contributing guide"
git push -q
remember origin_main
git switch -q -c feature/gift-cards
as lena; write src/giftcard.js "// Gift cards (work in progress)" "function redeem(card, cart) {" "  return cart;" "}"
commit "Start gift card redemption"
git push -q -u origin feature/gift-cards
remember gift_cards
git switch -q main
