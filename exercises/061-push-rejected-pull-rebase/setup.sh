R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/dev"
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin "$R"
git push -q -u origin main
as lena; append src/cart.js "" "function itemCount(cart) {" "  return cart.items.reduce((n, i) => n + i.qty, 0);" "}"
commit "Add itemCount helper"
git push -q

# You clone and start working on main (the storefront team does trunk-based development).
cd "$LG_DIR"
git clone -q "$R" repo
git -C repo config user.name "$LG_LEARNER_NAME"
git -C repo config user.email "$LG_LEARNER_EMAIL"
cd "$LG_DIR/repo"
as you
write src/banner.js "// Free-shipping banner" "function bannerText(total) {" "  const left = 5000 - total;" "  return left > 0 ? 'Add ' + left + ' cents for free shipping' : 'You get free shipping!';" "}" "" "module.exports = { bannerText };"
commit "Add free-shipping banner"
append src/cart.js "" "// The cart page shows bannerText(total(cart)) above the checkout button."
commit "Show banner on cart page"

# Meanwhile Dev pushes a fix to main.
cd "$LG_DIR/.team/dev"
as dev
replace src/price.js "\(cents \/ 100\)\.toFixed\(2\)" "(Math.round(cents) \/ 100).toFixed(2)"
commit "Round cents before formatting prices"
git push -q
remember dev_fix
