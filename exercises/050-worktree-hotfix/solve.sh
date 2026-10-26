cd repo
git worktree add -q -b hotfix/empty-cart-crash ../hotfix main
cd ../hotfix
write src/checkout.js \
  "// Checkout" \
  "function shippingFor(cart) {" \
  "  if (cart.items.length === 0) return 0;" \
  "  return cart.items[0].weight > 5000 ? 900 : 499;" \
  "}" \
  "" \
  "module.exports = { shippingFor };"
./test.sh >/dev/null
git commit -q -am "Fix checkout crash on empty cart"
git switch -q main
git merge -q --ff-only hotfix/empty-cart-crash
cd ../repo
git worktree remove ../hotfix
