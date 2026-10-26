R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write VERSION "2.5.0"
as maya; commit "Initial storefront"
git remote add origin "$R"
git push -q -u origin main
git switch -q -c release/2.5
commit "Cut release/2.5" --allow-empty
git push -q -u origin release/2.5
git switch -q -c feature/reviews main
as lena; write src/reviews.js "// Product reviews" "function averageRating(reviews) {" "  return reviews.reduce((s, r) => s + r.stars, 0) / reviews.length;" "}" "" "module.exports = { averageRating };"
commit "Add product reviews module"
git push -q -u origin feature/reviews
git switch -q main

cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git config --unset pull.rebase 2>/dev/null || true
git branch -q --track feature/reviews origin/feature/reviews
git branch -q --track release/2.5 origin/release/2.5
as you

# feature/reviews: two local, unpushed commits.
git switch -q feature/reviews
replace src/reviews.js "  return reviews.reduce" "  if (reviews.length === 0) return 0;\n  return reviews.reduce"
commit "Handle products without reviews"
append src/reviews.js "" "function stars(n) {" "  return '*'.repeat(Math.round(n));" "}"
commit "Render ratings as stars"

# release/2.5: a version bump that QA already tested (the tag is on the server).
git switch -q release/2.5
write VERSION "2.5.1"
commit "Bump version to 2.5.1"
git tag -a v2.5.1-rc1 -m "Release candidate 1 for 2.5.1 (QA build #318)"
git push -q origin v2.5.1-rc1
remember rc1
git switch -q main

# Meanwhile on the server…
cd "$LG_DIR/.team/maya"
day 1
as dev;  git switch -q main
         append src/cart.js "" "function clear(cart) {" "  cart.items = [];" "  return cart;" "}"; commit "Add clear() to cart"
         append src/price.js "// prices are always integer cents"; commit "Document price units"
         git push -q origin main
remember main_tip
as lena; git switch -q feature/reviews
         write docs/reviews.md "# Reviews" "" "Product asked: weight recent reviews higher (later)."; commit "Document the reviews roadmap"
         git push -q origin feature/reviews
remember lena_tip
as dev;  git switch -q release/2.5
         write src/cart.js "// Shopping cart" "function addItem(cart, item) {" "  cart.items = cart.items || [];" "  cart.items.push(item);" "  return cart;" "}" "" "function total(cart) {" "  return (cart.items || []).reduce((sum, i) => sum + i.price * i.qty, 0);" "}" "" "module.exports = { addItem, total };"
         commit "Hotfix: crash on carts without items"
         git push -q origin release/2.5
remember hotfix
