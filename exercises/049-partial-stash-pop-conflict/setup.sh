new_bare "$LG_DIR/remotes/origin.git"
new_repo "$LG_DIR/.team/dev"
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin "$LG_DIR/remotes/origin.git"
git push -q -u origin main

git clone -q "$LG_DIR/remotes/origin.git" "$LG_DIR/repo"
cd "$LG_DIR/repo"; ensure_identity; git config advice.detachedHead false

# Dev pushes while you're working (you haven't fetched yet)
cd "$LG_DIR/.team/dev"
as dev
replace src/cart.js "function total\(cart\) \{\n" "function total(cart) {\n  if (!cart.items.length) return 0;\n"
commit "Return 0 early for empty carts"
git push -q origin main
remember dev

# your uncommitted work: a finished price fix + half-done bulk discount
cd "$LG_DIR/repo"
as you
replace src/cart.js "  return cart\.items\.reduce\(\(sum, i\) => sum \+ i\.price \* i\.qty, 0\);" "  const sum = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);\n  return bulkDiscount(sum, cart.items.length);"
append src/cart.js "" "// WIP: 5% off for 10+ items" "function bulkDiscount(sum, count) {" "  return count >= 10 ? Math.round(sum * 0.95) : sum;" "}"
replace src/price.js "\(cents \/ 100\)" "(Math.round(cents) \/ 100)"
