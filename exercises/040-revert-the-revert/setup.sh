keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_bare "$LG_DIR/remotes/origin.git"
git --git-dir="$LG_DIR/remotes/origin.git" config receive.denyNonFastForwards true

new_repo "$LG_DIR/.team/maya"
git remote add origin "$LG_DIR/remotes/origin.git"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

git switch -q -c feature/gift-cards
as lena
write src/giftcard.js "// Gift cards" "function balance(card) {" "  return card.amount - card.spent;" "}" "" "module.exports = { balance };"
commit "Add gift card model"
write src/giftcard.js "// Gift cards" "function balance(card) {" "  return card.amount - card.spent;" "}" "" \
  "function redeem(card, cents) {" "  // BUG: no check, the balance can go negative" "  card.spent += cents;" "  return card;" "}" "" \
  "module.exports = { balance, redeem };"
append src/cart.js "" "function applyGiftCard(cart, card) {" "  cart.giftCard = card;" "  return cart;" "}"
commit "Redeem gift cards at checkout"

git switch -q main
as dev
write src/shipping.js "// Shipping" "function shippingCost(total) {" "  return total >= 5000 ? 0 : 499;" "}" "" "module.exports = { shippingCost };"
commit "Add shipping cost rules"

as maya; tick
git merge -q --no-ff --no-edit feature/gift-cards
as dev
append README.md "" "Support: help@brightcart.example"
commit "Add support address to README"

# Yesterday: Maya pulled the feature out of main
as maya; tick
git revert -m 1 --no-edit HEAD~1 >/dev/null
as sam
append README.md "" "Holiday sale: Dec 1-3."
commit "Announce holiday sale"

# Today: Lena fixed the bug on her branch
git switch -q feature/gift-cards
as lena
replace src/giftcard.js "  \/\/ BUG: no check, the balance can go negative\n  card.spent \+= cents;" \
  "  if (cents > balance(card)) throw new Error('insufficient gift card balance');\n  card.spent += cents;"
commit "Reject redemptions above the card balance"
remember feature
git switch -q main
git push -q origin main feature/gift-cards
remember tip

cd "$LG_DIR"
git clone -q "$LG_DIR/remotes/origin.git" repo
cd repo
keep_everything
ensure_identity
git config advice.detachedHead false
