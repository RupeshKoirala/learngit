new_repo repo
brightcart_skeleton
write src/badge.js "// Cart badge in the header" "function badgeCount(cart) {" "  return cart.items.length + 1;" "}" "" "module.exports = { badgeCount };"
write src/payment.js "// Payments" "function charge(gateway, order) {" "  return gateway.charge(order, { timeout: 5000 });" "}" "" "module.exports = { charge };"
write src/tax.js "// Sales tax" "function tax(cents, rate) {" "  return Math.floor(cents * rate);" "}" "" "module.exports = { tax };"
as maya; commit "Initial storefront"
as bot;  commit "Release 2.0.0" --allow-empty; git tag -a v2.0.0 -m "2.0.0"
git branch release/2.x

as dev;  write src/giftcard.js "// Gift cards" "function GiftCard(code, balance) { return { code, balance }; }" "module.exports = { GiftCard };"
         commit "feat: gift cards"
as dev;  replace src/payment.js "  return gateway.charge\(order, \{ timeout: 5000 \}\);" "  return gateway.charge(order, { timeout: 5000, retries: 2 });"
         commit "fix: retry payment on gateway timeout"
remember f_pay
as lena; write styles/dark.css "@media (prefers-color-scheme: dark) { body { background: #111; color: #eee; } }"
         commit "feat: dark mode"
as maya; replace src/tax.js "Math\.floor\(cents \* rate\)" "Math.round(cents * rate)"
         commit "fix: round CA sales tax to the nearest cent"
remember f_tax

# backports to the 2.x line, done by different people with different habits
git switch -q release/2.x
as dev;  tick; git cherry-pick -x "$(cat "$LG_DIR/.lg/f_pay.commit")" >/dev/null
         git tag -a v2.0.1 -m "2.0.1"
as maya; tick; git cherry-pick "$(cat "$LG_DIR/.lg/f_tax.commit")" >/dev/null
         git commit -q --amend -m "Round tax correctly (backport for 2.x customers)"
         git tag -a v2.0.2 -m "2.0.2"
remember release
git switch -q main

as lena; replace src/badge.js "cart\.items\.length \+ 1" "cart.items.reduce((n, i) => n + i.qty, 0)"
         commit "fix: cart badge count off by one"
remember f_badge
as bot;  append test.sh "# runner v2"; commit "chore: bump test runner"
as bot;  commit "Release 3.0.0" --allow-empty; git tag -a v3.0.0 -m "3.0.0"
as dev;  write src/wishlist.js "// Wishlist (3.1)" "module.exports = {};"; commit "feat: wishlist"
remember main
as you
