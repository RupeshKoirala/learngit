new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "// TODO: removeItem" ; commit "Leave a TODO for removeItem"
as you
remember start

# Two unrelated pieces of work, done in one sitting:
#  (a) a new feature: removeItem + its docs
replace src/cart.js "\/\/ TODO: removeItem\n" "function removeItem(cart, id) {\n  cart.items = cart.items.filter(i => i.id !== id);\n  return cart;\n}\n"
replace src/cart.js "module.exports = \{ addItem, total \};" "module.exports = { addItem, removeItem, total };"
append README.md "" "## Cart API" "" "- addItem(cart, item)" "- removeItem(cart, id) — removes every line with that product id" "- total(cart)"
#  (b) a bug fix found on the way: prices like 1999.5 cents printed as \$20.00 instead of rounding first
replace src/price.js "\(cents \/ 100\)" "(Math.round(cents) \/ 100)"

# The final content both commits together must produce:
mkdir -p "$LG_DIR/.lg"; git add -A; git write-tree > "$LG_DIR/.lg/target.tree"; git reset -q

# Out of habit you already staged two of the files...
git add src/cart.js src/price.js
# ...and you have a personal scratch file that must never be committed.
write notes.txt "my notes - do not commit" "- ask Maya about coupon rules" "- removeItem: should it remove all qty?"
