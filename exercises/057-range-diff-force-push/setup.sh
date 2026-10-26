# 057 — git range-diff: what changed between v1 and v2 of a force-pushed PR branch?

new_bare "$LG_DIR/remotes/origin.git"
new_repo "$LG_DIR/.team/lena"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  write src/product.js "function productPage(p) { return p.name + ' ' + p.price; }" "module.exports = { productPage };"
commit "Add product pages"
git remote add origin "$LG_DIR/remotes/origin.git"
git push -q origin main

# PR v1 by Lena
git switch -q -c feature/wishlist
as lena
write src/wishlist.js \
  "// Wishlist" \
  "function add(list, id) {" \
  "  if (!list.includes(id)) list.push(id);" \
  "  return list;" \
  "}" \
  "" \
  "function remove(list, id) {" \
  "  return list.filter(x => x !== id);" \
  "}" \
  "" \
  "module.exports = { add, remove };"
commit "Add wishlist model"
write src/api/wishlist.js \
  "const wishlist = require('../wishlist');" \
  "" \
  "function handle(req, list) {" \
  "  if (req.method === 'POST') return wishlist.add(list, req.body.id);" \
  "  return list;" \
  "}" \
  "" \
  "module.exports = { handle };"
commit "Add wishlist API endpoint"
replace src/wishlist.js "\/\/ Wishlist\n" "\/\/ Wishlist\nconst MAX_ITEMS = 50;\n\n"
replace src/wishlist.js "  if \(!list.includes\(id\)\) list.push\(id\);" "  if (list.length >= MAX_ITEMS) return list;\n  if (!list.includes(id)) list.push(id);"
commit "Cap wishlist size"
replace src/api/wishlist.js "function handle\(req, list\) \{\n" "function handle(req, list) {\n  console.log('wishlist', req.method, list);\n"
commit "Add debug logging for wishlist"
remember debug
remember v1
git push -q origin feature/wishlist

# you cloned and reviewed v1 yesterday
cd "$LG_DIR"; git clone -q remotes/origin.git repo
cd repo; git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"; git config advice.detachedHead false

# overnight: main moves on, Lena rebases, edits one commit, rewords one, drops one, and force-pushes
day
cd "$LG_DIR/.team/lena"
git switch -q main
as maya; append src/product.js "// TODO: product images"; commit "Note product image TODO"
as dev;  write src/search.js "function search(q, items) { return items.filter(i => i.name.includes(q)); }"; commit "Add product search"
git push -q origin main
git switch -q feature/wishlist
as lena
todo=$(mktemp)
git log --reverse --format='%h %s' main..HEAD | awk '
  /Add wishlist API endpoint/ { print "reword " $0; next }
  /Cap wishlist size/         { print "edit " $0; next }
  /debug logging/             { print "drop " $0; next }
  { print "pick " $0 }' > "$todo"
tick
GIT_SEQUENCE_EDITOR="cp $todo" GIT_EDITOR="printf '%s\n\n%s\n' 'Add GET/POST /api/wishlist endpoint' 'POST adds an item, GET returns the list.' >" \
  git rebase -i main >/dev/null 2>&1
replace src/wishlist.js "MAX_ITEMS = 50" "MAX_ITEMS = 20"
git add -A; GIT_EDITOR=true git commit -q --amend --no-edit
GIT_EDITOR=true git rebase --continue >/dev/null 2>&1
rm -f "$todo"
remember v2
remember capv2
git push -q --force origin feature/wishlist

cd "$LG_DIR/repo"
