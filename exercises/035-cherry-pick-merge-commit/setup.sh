new_repo repo
brightcart_skeleton
write templates/product.html "<article class=\"product\">" "  <h1>{{name}}</h1>" "  <p class=\"price\">{{price}}</p>" "  <button class=\"add\">Add to cart</button>" "</article>"
write templates/footer.html "<footer>Brightcart — happy shoping!</footer>"
as maya; commit "Initial storefront"
as bot;  write VERSION "2.4.0"; commit "Release 2.4.0"; git tag v2.4.0
git branch release/2.4

as dev;  write src/recommend.js "// EXPERIMENTAL recommendations (flag: recs_v0)" "function recommend(user) { return []; }" "module.exports = { recommend };"
         commit "Experimental recommendations engine (behind flag)"

git switch -q -c lena/wishlist
as lena
write src/wishlist.js "// Wishlist" "function addToWishlist(list, productId) {" "  if (!list.includes(productId)) list.push(productId);" "  return list;" "}" "" "module.exports = { addToWishlist };"
commit "Add wishlist model"
replace templates/product.html '  <button class="add">Add to cart<\/button>' '  <button class="add">Add to cart<\/button>\n  <button class="wish" aria-label="Save to wishlist">♡<\/button>'
commit "Add wishlist button to product page"
append src/wishlist.js "" "function saveWishlist(list) { localStorage.setItem('wishlist', JSON.stringify(list)); }" "module.exports.saveWishlist = saveWishlist;"
commit "Persist wishlist in localStorage"

git switch -q main
as sam;  replace templates/footer.html "shoping" "shopping"; commit "Fix typo in footer"
as maya; tick; git merge -q --no-ff lena/wishlist -m "Merge pull request #42 from lena/wishlist" -m "Wishlist: save products for later"
remember merge
as bot;  write VERSION "2.5.0-dev"; commit "Start 2.5 development"
remember main

git switch -q release/2.4
as dev;  replace src/price.js "toFixed\(2\)" "toFixed(2) \/\/ TODO locale"; commit "Note: price locale follow-up"
remember release
git switch -q main
remember wish lena/wishlist
as you

_tmp="$LG_DIR/.lg/tmp"; rm -rf "$_tmp"; git clone -q . "$_tmp"
( cd "$_tmp" && git switch -q -c r origin/release/2.4 && git cherry-pick -m 1 "$(cat "$LG_DIR/.lg/merge.commit")" >/dev/null \
  && git rev-parse HEAD^{tree} > "$LG_DIR/.lg/expected.tree" )
rm -rf "$_tmp"
