keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_bare "$LG_DIR/remotes/origin.git"
# main is protected like on GitHub: force-pushes (non-fast-forward updates) are rejected
git --git-dir="$LG_DIR/remotes/origin.git" config receive.denyNonFastForwards true

# The team's history, built in a teammate's clone
new_repo "$LG_DIR/.team/maya"
git remote add origin "$LG_DIR/remotes/origin.git"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
as dev
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  // BUG: rounds to whole dollars, \$19.99 shows as \$20" \
  "  return '\$' + Math.round(cents / 100);" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
commit "Show prices as whole dollars"
remember bad
as lena
write src/badges.js "// Product badges" "function badgeFor(product) {" "  return product.isNew ? 'NEW' : '';" "}" "" "module.exports = { badgeFor };"
commit "Add NEW badge to product cards"
as maya
append README.md "" "Deploys go out from main every afternoon."
commit "Document the deploy schedule"
git push -q origin main
remember tip

# Your clone, up to date with origin
cd "$LG_DIR"
git clone -q "$LG_DIR/remotes/origin.git" repo
cd repo
keep_everything
ensure_identity
git config advice.detachedHead false
