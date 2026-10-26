R="$LG_DIR/remotes/origin.git"
new_bare "$R"
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write VERSION "2.2.0"
write src/tax.js "// Sales tax" "function tax(cents, rate) {" "  return cents * rate;" "}" "" "module.exports = { tax };"
as maya; commit "Initial storefront"
write VERSION "2.3.0"; commit "Release 2.3.0"
as bot;  git tag -a v2.3.0 -m "Brightcart 2.3.0"
as dev;  replace src/tax.js "return cents \* rate;" "return Math.round(cents * rate);"; commit "Fix tax rounding for CA"
as maya; write VERSION "2.3.1"; commit "Bump version to 2.3.1"
remember right_231
# The release bot tagged the wrong commit (the fix, before the version bump): VERSION still says 2.3.0 there.
as bot;  git tag -a v2.3.1 -m "Brightcart 2.3.1" HEAD~1
remember wrong_231 HEAD~1
git remote add origin "$R"
git push -q -u origin main
git push -q origin v2.3.0 v2.3.1
git rev-parse v2.3.0 > "$LG_DIR/.lg/tag230.obj"

# Dev clones (and therefore has the wrong v2.3.1).
cd "$LG_DIR/.team"
git clone -q "$R" dev

# You clone and work on 2.4.
cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git tag bisect-good v2.3.0                      # leftovers from a bisect session
as lena; write src/wishlist.js "// Wishlist" "function add(list, id) {" "  return list.concat(id);" "}"; commit "Add wishlist"
as you;  git tag tmp-before-refactor            # a private bookmark
as lena; replace src/wishlist.js "return list.concat\(id\);" "return list.includes(id) ? list : list.concat(id);"; commit "Ignore duplicate wishlist items"
as maya; write VERSION "2.4.0"; commit "Release 2.4.0"
git push -q origin main
remember release_240
as you
