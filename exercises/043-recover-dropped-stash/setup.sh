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
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

as you
# Some noise: an amended commit leaves an unreachable commit behind
append README.md "" "Contributors: see CONTRIBUTORS"
commit "Update README"
append README.md "Questions? Ask in #brightcart-dev"
tick; git add -A; git commit -q --amend --no-edit
remember main

# Two weeks ago: a dark-mode experiment, stashed
tick
write src/theme.css "/* dark mode experiment */" "body { background: #111; color: #eee; }"
git add src/theme.css
append README.md "Try the dark mode with ?theme=dark"
git stash push -q -m "experiment: dark mode"

# Yesterday: real work on express checkout, stashed to review a teammate's PR
tick
append src/cart.js "" "function expressCheckout(cart, savedCard) {" "  return { items: cart.items, card: savedCard, oneClick: true };" "}"
write src/express.js "// Express checkout button" "function renderExpressButton(cart) {" "  return '<button class=\"express\">Buy now</button>';" "}" "" "module.exports = { renderExpressButton };"
git add src/express.js
git stash push -q -m "express checkout button"
remember express stash@{0}

# Today: "let me just get rid of that old dark-mode stash…"
tick
git stash clear
