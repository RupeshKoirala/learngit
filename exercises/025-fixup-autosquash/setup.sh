giftcard() {   # giftcard <code length>
  write src/giftcard.js "// Gift cards: 16-character codes like ABCD1234EFGH5678" "const CODE_FORMAT = /^[A-Z0-9]{$1}\$/;" "" "function isValidCode(code) {" "  return CODE_FORMAT.test(code);" "}" "" "module.exports = { isValidCode };"
}
checkout() {   # checkout <line where the balance check goes>
  write src/checkout.js "// Checkout: pay (part of) an order with a gift card" "function redeem(card, amount) {" "$1" "  card.balance -= amount;" "  return card;" "}" "" "module.exports = { redeem };"
}

new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/gift-cards
as you
giftcard 61
commit "Add gift card model"
checkout "  // TODO: check the card balance"
commit "Redeem gift cards at checkout"
append README.md "" "Gift cards: enter the 16-character code at checkout."
commit "Document gift cards"
remember original

# Maya reviewed the PR. You've already fixed both comments locally, but haven't committed yet.
day
giftcard 16
checkout "  if (amount > card.balance) throw new Error('Insufficient gift card balance');"
git add -A
git write-tree > "$LG_DIR/.lg/fixed.tree"
git reset -q
