R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/lena"
brightcart_skeleton
as maya; commit "Initial storefront"
write src/tax.js "// Sales tax" "function tax(cents, rate) {" "  return cents * rate;" "}" "" "module.exports = { tax };"
commit "Add sales tax"
git remote add origin "$R"
git push -q -u origin main

# Lena starts a hotfix branch and pushes the first commit.
git switch -q -c hotfix/tax-rounding
as lena; replace src/tax.js "return cents \* rate;" "return Math.round(cents * rate);"
commit "Round sales tax to whole cents"
git push -q -u origin hotfix/tax-rounding
H1=$(git rev-parse HEAD)

# You clone the repo.
cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
as you
# Lena pasted a commit hash in chat; you made a branch from it (no upstream).
git branch hotfix/tax-rounding "$H1"

# Your feature branch: never pushed yet.
git switch -q -c feature/wishlist main
write src/wishlist.js "// Wishlist" "function addToWishlist(list, productId) {" "  return list.includes(productId) ? list : list.concat(productId);" "}" "" "module.exports = { addToWishlist };"
commit "Add wishlist module"
append src/wishlist.js "// Limit: 100 items per customer"
commit "Document wishlist limit"

# A private experiment, accidentally created from origin/main, so it "tracks" origin/main.
git branch -q --track experiment/search-ranking origin/main
git switch -q experiment/search-ranking
write src/ranking.js "// Experimental: rank search results by margin" "function rank(products) {" "  return products.slice().sort((a, b) => b.margin - a.margin);" "}"
commit "Try ranking search results by margin"

# A small chore branch, never pushed.
git switch -q -c chore/update-deps main
write package.json "{" "  \"name\": \"brightcart\"," "  \"devDependencies\": { \"eslint\": \"^9.0.0\" }" "}"
commit "Add eslint as a dev dependency"
git switch -q main

# Lena keeps working on the hotfix; you fetch.
cd "$LG_DIR/.team/lena"
append src/tax.js "// Rounding: half up, per line item (finance confirmed)"
commit "Document tax rounding rule"
append test.sh "# tax: tax(199, 0.0725) must be 14"
commit "Add tax rounding test note"
git push -q
remember hotfix_tip
cd "$LG_DIR/repo"
git fetch -q
