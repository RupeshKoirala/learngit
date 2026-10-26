new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as bot;  write VERSION "3.1.0"; commit "Release 3.1.0"
git branch release/3.1

# production hotfixes on the release branch
git switch -q release/3.1
as dev
replace src/cart.js 'sum \+ i\.price \* i\.qty' 'sum + i.price * (i.qty || 1)'
commit "Fix total() for items without a qty"
as bot; write VERSION "3.1.1"; commit "Release 3.1.1"
as dev
write src/price.js \
  "// Price formatting" \
  "function formatPrice(cents) {" \
  "  const sign = cents < 0 ? '-' : '';" \
  "  return sign + '\$' + (Math.abs(cents) / 100).toFixed(2);" \
  "}" "" "module.exports = { formatPrice };"
commit "Fix formatPrice for negative amounts"
remember release

# meanwhile main moved on: Lena refactored total(), and main is on the 3.2 dev cycle
git switch -q main
as bot;  write VERSION "3.2.0-dev"; commit "Start 3.2 development"
as lena
write src/cart.js \
  "// Shopping cart" \
  "function addItem(cart, item) {" \
  "  cart.items.push(item);" \
  "  return cart;" \
  "}" \
  "" \
  "function lineTotal(item) {" \
  "  return item.price * item.qty;" \
  "}" \
  "" \
  "function total(cart) {" \
  "  return cart.items.map(lineTotal).reduce((a, b) => a + b, 0);" \
  "}" \
  "" \
  "module.exports = { addItem, lineTotal, total };"
commit "Refactor: extract lineTotal() from total()"
remember main
as you
