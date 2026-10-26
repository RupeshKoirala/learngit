cart_js() {   # cart_js <debug:0|1> <fix:0|1> <feature:0|1>   prints src/cart.js in the requested state
  echo "// Shopping cart"
  echo "function addItem(cart, item) {"
  [ "$1" = 1 ] && echo "  console.log('DEBUG addItem', JSON.stringify(item));"
  echo "  cart.items.push(item);"
  echo "  return cart;"
  echo "}"
  echo ""
  echo "function removeItem(cart, id) {"
  echo "  cart.items = cart.items.filter(i => i.id !== id);"
  echo "  return cart;"
  echo "}"
  echo ""
  echo "function itemCount(cart) {"
  echo "  return cart.items.reduce((n, i) => n + i.qty, 0);"
  echo "}"
  echo ""
  echo "function isEmpty(cart) {"
  echo "  return cart.items.length === 0;"
  echo "}"
  echo ""
  echo "function total(cart) {"
  if [ "$2" = 1 ]; then
    echo "  // items added from the wishlist have no qty yet: treat them as 1"
    echo "  return cart.items.reduce((sum, i) => sum + i.price * (i.qty || 1), 0);"
  else
    echo "  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);"
  fi
  echo "}"
  echo ""
  echo "function hasItem(cart, id) {"
  echo "  return cart.items.some(i => i.id === id);"
  echo "}"
  echo ""
  echo "function findItem(cart, id) {"
  echo "  return cart.items.find(i => i.id === id);"
  echo "}"
  echo ""
  echo "function lineTotal(item) {"
  echo "  return item.price * item.qty;"
  echo "}"
  echo ""
  if [ "$3" = 1 ]; then
    echo "function clearCart(cart) {"
    echo "  cart.items = [];"
    echo "  return cart;"
    echo "}"
    echo ""
    echo "module.exports = { addItem, removeItem, itemCount, isEmpty, total, hasItem, findItem, lineTotal, clearCart };"
  else
    echo "module.exports = { addItem, removeItem, itemCount, isEmpty, total, hasItem, findItem, lineTotal };"
  fi
}

new_repo repo
brightcart_skeleton
cart_js 0 0 0 > src/cart.js
as maya; commit "Initial storefront"
as lena; append README.md "" "Cart helpers live in src/cart.js."; commit "Mention cart helpers in README"
as you
remember start

# What the two commits together must produce (no debug line):
mkdir -p "$LG_DIR/.lg"
cart_js 0 1 1 > src/cart.js; git add -A; git write-tree > "$LG_DIR/.lg/target.tree"; git reset -q
# What's really on disk: fix + feature + a debug line you want to keep locally for now.
cart_js 1 1 1 > src/cart.js
