UP="$LG_DIR/remotes/brightcart.git"     # the company repository (you can't push here)
FORK="$LG_DIR/remotes/fork.git"         # your fork of it
new_bare "$UP"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write src/product.js "// Product page" "function productTitle(p) {" "  return p.name;" "}" "" "module.exports = { productTitle };"
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function isEmpty(cart) {" "  return cart.items.length === 0;" "}"; commit "Add isEmpty to cart"
git remote add origin "$UP"
git push -q -u origin main

# Two weeks ago you forked the repo (the fork is a copy of the company repo at that moment).
day 1
git clone -q --bare "$UP" "$FORK"

cd "$LG_DIR"
git clone -q "$FORK" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
as you
git switch -q -c feature/size-guide
write src/sizeguide.js "// Size guide" "const SIZES = ['XS', 'S', 'M', 'L', 'XL'];" "function sizeGuide() {" "  return SIZES.join(' / ');" "}" "" "module.exports = { sizeGuide };"
commit "Add size guide data"
replace src/product.js "  return p.name;" "  return p.name + (p.sized ? ' (see size guide)' : '');"
commit "Link size guide from product title"
git push -q -u origin feature/size-guide
git switch -q main

# The company repo moves on; your fork's main doesn't (forks don't sync themselves).
cd "$LG_DIR/.team/maya"
day 10
as lena; replace src/price.js "'\\\$' \+" "'USD ' +"; commit "Show prices with currency code"
as dev;  write src/stock.js "// Stock levels" "function inStock(p) {" "  return p.stock > 0;" "}" "" "module.exports = { inStock };"; commit "Add stock helper"
as maya; append README.md "" "Contributions come in as pull requests from forks."; commit "Explain the fork workflow in README"
git push -q
remember upstream_main
