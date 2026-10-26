new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "// TODO stock"; commit "fixed stuff."
as lena; write src/cart.css ".cart { display: grid; }"; commit "WIP"
as dev;  replace src/cart.js "\/\/ TODO stock\n" ""
         commit "Updated the cart file because the TODO was not needed anymore and also some other cleanup"
as you
remember start

# The work you and Lena pair-programmed on this morning (issue #12), already staged:
write src/stock.js \
  "// Stock checks" \
  "function canAdd(cart, item, stock) {" \
  "  const inCart = cart.items.filter(i => i.id === item.id).reduce((n, i) => n + i.qty, 0);" \
  "  return inCart + item.qty <= (stock[item.id] || 0);" \
  "}" \
  "" \
  "module.exports = { canAdd };"
replace src/cart.js "\/\/ Shopping cart\nfunction addItem\(cart, item\) \{\n" \
  "\/\/ Shopping cart\nconst { canAdd } = require('.\/stock');\n\nfunction addItem(cart, item, stock) {\n  if (stock && !canAdd(cart, item, stock)) throw new Error('OUT_OF_STOCK');\n"
git add -A
mkdir -p "$LG_DIR/.lg"; git write-tree > "$LG_DIR/.lg/target.tree"
