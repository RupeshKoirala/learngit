# Lena's shared design library, published as its own repo.
new_bare "$LG_DIR/remotes/ui-kit.git"
new_repo "$LG_DIR/.team/ui-kit"
as lena
write README.md "# Brightcart UI kit" "" "Shared CSS components for every Brightcart app."
write VERSION "1.0.0"
write buttons.css ".btn { padding: 8px 16px; border-radius: 4px; }"
commit "feat: button styles"
write card.css ".card { border: 1px solid #ddd; border-radius: 8px; }"
commit "feat: card component"
git tag -a v1.0.0 -m "UI kit 1.0.0"
git remote add origin "$LG_DIR/remotes/ui-kit.git"
git push -q origin main --tags

# The storefront, on the fake GitHub.
new_bare "$LG_DIR/remotes/storefront.git"
new_repo "$LG_DIR/.team/storefront"
brightcart_skeleton
as maya; commit "chore: initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "feat(cart): add removeItem"
git remote add origin "$LG_DIR/remotes/storefront.git"
git push -q origin main

# Your clone.
cd "$LG_DIR"
git clone -q "$LG_DIR/remotes/storefront.git" repo
cd repo
ensure_identity
as you
