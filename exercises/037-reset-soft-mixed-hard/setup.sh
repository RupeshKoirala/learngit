keep_everything() {   # never let auto-gc expire reflogs or prune objects in this sandbox
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_repo repo
keep_everything
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
write src/shipping.js "// Shipping" "function shippingCost(total) {" "  return 499;" "}" "" "module.exports = { shippingCost };"
commit "Add flat-rate shipping"
remember main main

git switch -q -c feature/free-shipping
as you
write src/shipping.js "// Shipping" "const FREE_SHIPING_FROM = 5000; // cents" "" "function shippingCost(total) {" \
  "  if (total >= FREE_SHIPING_FROM) return 0;" "  return 499;" "}" "" "module.exports = { shippingCost };"
commit "wip free shipping"
replace src/shipping.js "FREE_SHIPING_FROM" "FREE_SHIPPING_FROM"
commit "fix typo"
replace src/shipping.js "module.exports = \{ shippingCost \};" "module.exports = { shippingCost, FREE_SHIPPING_FROM };"
commit "export the threshold too"
remember original

# Personal scratch notes, accidentally staged with `git add .`
write notes.txt "my notes - do NOT commit" "- ask Sam if the threshold is \$50 or \$75" "- Lena wants the banner copy by Friday"
git add notes.txt
# A half-baked experiment you've decided to throw away (unstaged)
append src/price.js "" "// EXPERIMENT: multi-currency symbols, half done" "function symbolFor(currency) { return '?'; }"
