checkout_js() {   # checkout_js <comment> <methods>
  write src/checkout.js \
    "// Checkout configuration" \
    "$1" \
    "const PAYMENT_METHODS = [$2];" \
    "const CHECKOUT_BANNER = 'Free shipping on orders over \$50';" \
    "" \
    "module.exports = { PAYMENT_METHODS, CHECKOUT_BANNER };"
}

new_repo repo
brightcart_skeleton
checkout_js "// Accepted payment methods" "'card', 'paypal'"
as maya; commit "Initial storefront"

# your feature branch
git switch -q -c feature/gift-cards
as you
write src/giftcard.js "// Gift card balance lookup" "function balance(cards, code) {" \
  "  const c = cards.find(x => x.code === code);" "  return c ? c.cents : 0;" "}" "" "module.exports = { balance };"
commit "Add gift card balance lookup"
checkout_js "// Gift cards accepted at checkout (SHOP-215)" "'card', 'paypal', 'giftcard'"
commit "Accept gift cards at checkout"

# meanwhile Lena's Apple Pay PR was merged to main
git switch -q main
as lena
write src/applepay.js "// Apple Pay session helper" "function startSession(merchantId) {" \
  "  return { merchantId, started: true };" "}" "" "module.exports = { startSession };"
commit "Add Apple Pay session helper"
checkout_js "// Apple Pay enabled for iOS users (SHOP-212)" "'card', 'paypal', 'applepay'"
commit "Enable Apple Pay at checkout"

git switch -q feature/gift-cards
as you
remember feature feature/gift-cards
remember main main
