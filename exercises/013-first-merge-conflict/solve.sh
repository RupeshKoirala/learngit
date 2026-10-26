cd repo
git switch -q feature/gift-cards
git merge -q main >/dev/null 2>&1 || true   # stops with a conflict in src/checkout.js
write src/checkout.js \
  "// Checkout configuration" \
  "// Payment methods: Apple Pay (SHOP-212), gift cards (SHOP-215)" \
  "const PAYMENT_METHODS = ['card', 'paypal', 'applepay', 'giftcard'];" \
  "const CHECKOUT_BANNER = 'Free shipping on orders over \$50';" \
  "" \
  "module.exports = { PAYMENT_METHODS, CHECKOUT_BANNER };"
git add src/checkout.js
git commit -q --no-edit
