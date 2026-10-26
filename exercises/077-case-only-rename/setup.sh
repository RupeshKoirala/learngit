# readme.md and src/Utils.js should be README.md and src/utils.js. Lena's new code already requires './utils',
# which works on her Mac (case-insensitive disk) but breaks Linux CI.
new_repo repo
brightcart_skeleton
mv README.md tmp.md; mv tmp.md readme.md
write src/Utils.js "// Shared helpers" "function clamp(n, lo, hi) {" "  return Math.max(lo, Math.min(hi, n));" "}" "" "module.exports = { clamp };"
replace src/cart.js "\/\/ Shopping cart\n" "\/\/ Shopping cart\nconst { clamp } = require('.\/Utils');\n"
as maya; commit "Initial storefront"
as lena
write src/checkout.js "// Checkout" "const { clamp } = require('./utils');   // works on my Mac..." \
  "function qty(n) { return clamp(n, 1, 99); }" "module.exports = { qty };"
commit "Add checkout quantity limits"
as you
remember original
