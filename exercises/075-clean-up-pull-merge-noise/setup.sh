# You work on main and `git pull` (merge mode) three times — now your 4 commits are tangled in 3 merge bubbles.
new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git
git push -q -u origin main
git config pull.rebase false
T="$LG_DIR/.team/team"
git clone -q "$LG_DIR/remotes/origin.git" "$T"
team() { ( cd "$T" && git pull -q --no-rebase origin main && "$@" && git push -q origin main ); }

as you;  write src/reviews.js "// Product reviews" "function review(productId, rating, text) {" "  return { productId: productId, rating: rating, text: text };" "}" "module.exports = { review };"
         commit "Add product review model"
as dev;  team eval 'append src/cart.js "// cart: max 99 items"; commit "Limit cart size"'
as you;  git pull -q --no-edit
         replace src/reviews.js "  return \{" "  if (rating < 1 || rating > 5) throw new Error('rating must be 1-5');\n  return {"
         commit "Validate review rating"
as lena; team eval 'replace src/price.js "Price formatting" "Price formatting (USD)"; commit "Clarify price currency"'
as you;  git pull -q --no-edit
         append src/reviews.js "" "function average(reviews) {" "  return reviews.reduce((s, r) => s + r.rating, 0) / reviews.length;" "}"
         commit "Add average rating"
as maya; team eval 'append .gitignore "dist/"; commit "Ignore dist folder"'
as you;  git pull -q --no-edit
         write docs/reviews.md "# Reviews" "" "Ratings are 1-5. average() returns the mean rating."
         commit "Document reviews"
as dev;  team eval 'append src/cart.js "// cart: free shipping over \$50"; commit "Note free-shipping rule"'
         ( cd "$T" && remember team )
as you
remember original
