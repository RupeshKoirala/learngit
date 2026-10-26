cd repo
git rebase main >/dev/null 2>&1 || true          # stops on src/cart.js
git rebase --skip >/dev/null 2>&1 || true        # main already has the fix; stops on src/price.js
write src/price.js "// Price formatting" "function formatPrice(cents, symbol = '\$') {" "  const sign = cents < 0 ? '-' : '';" "  return sign + symbol + (Math.abs(cents) / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
git add src/price.js
git rebase --continue >/dev/null
