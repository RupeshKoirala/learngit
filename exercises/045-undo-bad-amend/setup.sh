keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_repo repo
keep_everything
brightcart_skeleton
as maya; commit "Initial storefront"
remember base

as you
git switch -q -c feature/order-emails
write src/email.js "// Order confirmation email" "function confirmationEmail(order) {" \
  "  return 'Thanks for your order #' + order.id + '!';" "}" "" "module.exports = { confirmationEmail };"
commit "Add order confirmation email"
remember original

# Next task: a price rounding fix, staged…
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  return '\$' + (Math.round(cents) / 100).toFixed(2);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
git add src/price.js
# …and then muscle memory: `git commit --amend --no-edit` instead of `git commit -m "Fix price rounding"`
tick
git commit -q --amend --no-edit
remember amended
