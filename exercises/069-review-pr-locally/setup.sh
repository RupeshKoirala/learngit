R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write src/shipping.js "// Shipping" "function shippingCost(total) {" "  return 599;" "}" "" "module.exports = { shippingCost };"
as maya; commit "Initial storefront"
as sam;  write docs/shipping.md "# Shipping rules (product spec)" "" "- Orders of \$50.00 or more ship free." "- Everything else: flat \$5.99." "- Amounts are integer cents in code (\$50.00 = 5000)."
         commit "Spec: free shipping threshold"
git remote add origin "$R"
git push -q -u origin main
remember main_tip

cd "$LG_DIR"
git clone -q "$R" repo
git -C repo config user.name "$LG_LEARNER_NAME"; git -C repo config user.email "$LG_LEARNER_EMAIL"

# Lena opens PR #42 from her fork. GitHub stores every PR's commits at refs/pull/<n>/head in the base repo.
cd "$LG_DIR/.team/maya"
git switch -q -c lena-free-shipping
as lena
write src/shipping.js "// Shipping" "const FREE_SHIPPING_FROM = 5000; // cents" "" "function shippingCost(total) {" "  // BUG? not sure if exactly 50.00 should ship free, will check" "  return total > FREE_SHIPPING_FROM ? 0 : 599;" "}" "" "module.exports = { shippingCost, FREE_SHIPPING_FROM };"
commit "Free shipping above 50 dollars"
append README.md "" "Free shipping: see docs/shipping.md"
commit "Mention free shipping in README"
git push -q origin HEAD:refs/pull/42/head
remember pr42
# Jo's PR #43 (docs only).
git switch -q -c jo-typo main
as jo; replace README.md "Tiny demo shop" "A tiny demo shop"; commit "Fix README wording"
git push -q origin HEAD:refs/pull/43/head
remember pr43
git switch -q main
