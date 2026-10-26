new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

# A big checkout rewrite, split into three small stacked PRs.
as you
git switch -q -c feature/checkout-1-model
write src/order.js "// Order model" "function createOrder(cart, address) {" "  return { items: cart.items, address, status: 'new' };" "}" "" "module.exports = { createOrder };"
commit "Add Order model"
write src/order.js "// Order model" "function createOrder(cart, address) {" "  if (!address || !address.zip) throw new Error('Address needs a ZIP code');" "  return { items: cart.items, address, status: 'new' };" "}" "" "module.exports = { createOrder };"
commit "Validate order addresses"

git switch -q -c feature/checkout-2-api
write src/order-api.js "// POST /orders" "const { createOrder } = require('./order');" "" "function postOrder(req, res) {" "  res.status(201).json(createOrder(req.body.cart, req.body.address));" "}" "" "module.exports = { postOrder };"
commit "Add POST /orders endpoint"

git switch -q -c feature/checkout-3-ui
write src/checkout-page.js "// Checkout page" "async function placeOrder(cart, address) {" "  const res = await fetch('/orders', { method: 'POST', body: JSON.stringify({ cart, address }) });" "  return res.json();" "}" "" "module.exports = { placeOrder };"
commit "Add checkout page"
append src/checkout-page.js "" "function confirmation(order) {" "  return 'Thanks! Order status: ' + order.status;" "}"
commit "Show order confirmation"

remember s1 feature/checkout-1-model
remember s2 feature/checkout-2-api
remember s3 feature/checkout-3-ui

git switch -q main
day
as maya; append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

git switch -q feature/checkout-3-ui
