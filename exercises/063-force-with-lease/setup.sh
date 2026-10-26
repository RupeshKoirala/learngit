R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
as maya; commit "Initial storefront"
write src/order.js "// Orders" "function createOrder(cart) {" "  return { items: cart.items, notes: '' };" "}" "" "module.exports = { createOrder };"
commit "Add order model"
git remote add origin "$R"
git push -q -u origin main

cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
as you
git switch -q -c feature/order-notes
replace src/order.js "function createOrder\(cart\) \{\n  return \{ items: cart.items, notes: '' \};" "function createOrder(cart, notes) {\n  return { items: cart.items, notes: notes || '' };"
commit "Add notes field to orders"
write src/receipt.js "// Receipt" "function receipt(order) {" "  return 'Items: ' + order.items.length + '\\nNotes: ' + order.notes;" "}" "" "module.exports = { receipt };"
commit "Show order notes on receipt"
append src/order.js "" "const MAX_NOTE_LENGTH = 500;"
commit "Add order note lenght limit"
git push -q -u origin feature/order-notes

# Main moves on; Maya asks you to rebase your PR before she reviews it.
cd "$LG_DIR/.team/maya"
day 1
as maya
replace src/price.js "\(cents \/ 100\)" "(Math.round(cents) \/ 100)"
commit "Round cents before formatting"
append README.md "" "Orders: see src/order.js"
commit "Document the order model"
git push -q
remember main_tip

cd "$LG_DIR/repo"
as you
git fetch -q
git rebase -q origin/main
mkdir -p "$LG_DIR/.lg"; echo "$LG_CLOCK" > "$LG_DIR/.lg/clock"
