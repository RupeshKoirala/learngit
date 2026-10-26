R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write CHANGELOG.md "# Changelog" "" "## 2.4.0 (unreleased)"
write src/shipping.js "// Shipping" "function shippingRate(zone) {" "  return zone === 'US' ? 599 : 1499;" "}" "" "module.exports = { shippingRate };"
as maya; commit "Initial storefront"
git remote add origin "$R"
git push -q -u origin main
git switch -q -c release/2.4
append CHANGELOG.md "" "- Release branch cut from main"
commit "Cut release/2.4"
git push -q -u origin release/2.4

# Dev clones now and starts a change on the release branch.
cd "$LG_DIR/.team"
git clone -q "$R" dev
cd "$LG_DIR/.team/dev"
git switch -q release/2.4

# You clone, add two commits to the release branch, and push them.
cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git switch -q release/2.4
as you
write src/tax.js "// Sales tax rates by state" "const RATES = { CA: 0.0725, NY: 0.04 };" "" "function taxRate(state) {" "  return RATES[state] || 0;" "}" "" "module.exports = { taxRate };"
commit "Add CA and NY sales tax rates"
append CHANGELOG.md "- Sales tax for CA and NY"
commit "Changelog: sales tax"
git push -q
remember yours

# Dev, with an old copy of the branch, commits, gets "rejected", and... forces it.
cd "$LG_DIR/.team/dev"
as dev
write src/shipping.js "// Shipping" "const CACHE = {};" "function shippingRate(zone) {" "  if (!(zone in CACHE)) CACHE[zone] = zone === 'US' ? 599 : 1499;" "  return CACHE[zone];" "}" "" "module.exports = { shippingRate };"
commit "Cache shipping rates"
append src/shipping.js "// cache key is the zone code, upper-case"
commit "Document shipping cache key"
git push -q --force origin release/2.4
remember dev_tip

# You fetch, see the branches diverged, and follow bad advice from a chat thread.
cd "$LG_DIR/repo"
as you
git fetch -q
git reset -q --hard origin/release/2.4
