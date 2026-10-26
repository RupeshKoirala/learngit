new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"
git branch release/1.0
git remote add origin ../remotes/origin.git
git push -q -u origin main release/1.0 2>/dev/null

# an old promo banner feature, merged months ago (GitHub auto-deleted the remote branch after merge)
git switch -q -c feature/old-promo-banner
as lena
write src/banner.js "// Promo banner" "module.exports = { text: 'Spring sale: 20% off' };"
commit "Add spring promo banner"
git push -q -u origin feature/old-promo-banner 2>/dev/null
git switch -q main
as maya; git merge -q --no-ff --no-edit feature/old-promo-banner; tick
git --git-dir="$LG_DIR/remotes/origin.git" branch -q -D feature/old-promo-banner

# an experiment that went nowhere (decision in last sprint's retro: drop it)
git switch -q -c spike/graphql-experiment
as you
write src/graphql.js "// GraphQL experiment" "const schema = 'type Query { products: [Product] }';" "module.exports = { schema };"
commit "Try a GraphQL schema for products"
append src/graphql.js "// TODO resolvers"
commit "WIP resolvers"
git switch -q main

# product search: your PR, merged with a merge commit
git switch -q -c feature/search
write src/search.js "// Product search" "function search(products, q) {" \
  "  return products.filter(p => p.name.toLowerCase().includes(q.toLowerCase()));" "}" "" "module.exports = { search };"
commit "Add product search"
append README.md "" "Search: type in the box at the top."
commit "Document search"
git push -q -u origin feature/search 2>/dev/null
git switch -q main
as maya; git merge -q --no-ff --no-edit feature/search; tick

# a tiny footer typo fix, fast-forwarded
as you
git switch -q -c fix/typo-footer
write src/footer.js "// Footer" "module.exports = { text: '© Brightcart. All rights reserved.' };"
commit "Fix typo in footer"
git push -q -u origin fix/typo-footer 2>/dev/null
git switch -q main
git merge -q --ff-only fix/typo-footer
git push -q origin main 2>/dev/null

# your current WIP: not merged, very much alive (pushed as a backup)
git switch -q -c feature/checkout-redesign
write src/checkout.js "// Checkout v2 (WIP)" "function steps() { return ['cart', 'address', 'payment']; }" "module.exports = { steps };"
commit "WIP: checkout steps"
git push -q -u origin feature/checkout-redesign 2>/dev/null

git fetch -q
git switch -q feature/search
remember main main
remember release release/1.0
remember wip feature/checkout-redesign
