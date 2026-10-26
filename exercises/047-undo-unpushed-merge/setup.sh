keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_bare "$LG_DIR/remotes/origin.git"
new_repo repo
keep_everything
git remote add origin "$LG_DIR/remotes/origin.git"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

# Lena's sorting branch, forked here
git switch -q -c feature/sort-by-price
as lena
replace src/cart.js "  return cart.items.reduce\(\(sum, i\) => sum \+ i.price \* i.qty, 0\);" \
  "  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0); \/\/ cents"
append src/cart.js "" "function sortByPrice(items) {" "  return items.slice().sort((a, b) => a.price - b.price);" "}"
replace src/price.js "  return '\\\$' \+ \(cents \/ 100\).toFixed\(2\);" "  return '\\\$' + (cents \/ 100).toFixed(2); \/\/ used for sorting labels"
commit "Sort products by price"

# Meanwhile main changed the same lines
git switch -q main
as maya
replace src/cart.js "  return cart.items.reduce\(\(sum, i\) => sum \+ i.price \* i.qty, 0\);" \
  "  return Math.round(cart.items.reduce((sum, i) => sum + i.price * i.qty, 0));"
replace src/price.js "  return '\\\$' \+ \(cents \/ 100\).toFixed\(2\);" "  return 'US\\\$' + (cents \/ 100).toFixed(2);"
commit "Round totals and prefix prices with US\$"

# Dev's search branch
git switch -q -c feature/search
as dev
write src/search.js "// Product search" "function search(products, q) {" "  return products.filter(p => p.name.includes(q));" "}" "" "module.exports = { search };"
commit "Add product search"
remember search
git switch -q main
git push -q -u origin main feature/search feature/sort-by-price
remember main main
remember sort feature/sort-by-price

# You merge search locally (Maya will later say: not yet!)
as you; tick
git merge -q --no-ff -m "Merge branch 'feature/search'" feature/search
# A note you're writing (uncommitted)
append README.md "" "Search: type in the box at the top of the shop."
# Then you start merging the sorting branch: conflicts in two files
tick
git merge --no-ff -m "Merge branch 'feature/sort-by-price'" feature/sort-by-price >/dev/null 2>&1 || true
# You resolved price.js and staged it…
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  return 'US\$' + (cents / 100).toFixed(2); // used for sorting labels" \
  "}" \
  "" \
  "module.exports = { formatPrice };"
git add src/price.js
# …cart.js is still full of conflict markers when Maya pings you.
