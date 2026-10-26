# Your laptop's repo config had your personal email. 2 old commits with it are already on origin/main,
# 5 newer ones on feature/wishlist-share are not pushed yet.
PERSONAL=night.owl.coder@mail.example
WORK=you@brightcart.example
me_as() { export GIT_AUTHOR_NAME="$LG_LEARNER_NAME" GIT_AUTHOR_EMAIL="$1" GIT_COMMITTER_NAME="$LG_LEARNER_NAME" GIT_COMMITTER_EMAIL="$1"; }

new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git

me_as "$WORK"
write src/wishlist.js "// Wishlist" "function create(user) { return { user: user, items: [] }; }" "module.exports = { create };"
commit "Add wishlist model"
me_as "$PERSONAL"
append src/wishlist.js "function add(list, item) { list.items.push(item); return list; }"
commit "Add items to wishlist"
append src/wishlist.js "function count(list) { return list.items.length; }"
commit "Count wishlist items"
as dev; append src/cart.js "// TODO move to wishlist"; commit "Note wishlist hand-off in cart"
git push -q -u origin main

day
me_as "$PERSONAL"
git config user.email "$PERSONAL"        # the root cause
git switch -q -c feature/wishlist-share
write src/share.js "// Share a wishlist" "function shareUrl(list) {" "  return '/w/' + list.user;" "}" "module.exports = { shareUrl };"
commit "Add wishlist share URL"
append src/share.js "// TODO: random slug instead of user id"; commit "Note slug TODO"
replace src/share.js "list.user;" "encodeURIComponent(list.user);"; commit "Escape user in share URL"
append README.md "" "Share your wishlist from the wishlist page."; commit "Document wishlist sharing"
write src/share.test.txt "shareUrl({user:'a b'}) => /w/a%20b"; commit "Add share URL example"

remember original
remember base origin/main
git log --reverse --format=%s origin/main..HEAD > "$LG_DIR/.lg/subjects"
