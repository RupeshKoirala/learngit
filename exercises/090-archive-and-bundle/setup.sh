new_repo repo
brightcart_skeleton
write VERSION "1.9.0"
write tests/cart.test.js "// cart tests" "require('../src/cart');"
write .github/workflows/ci.yml "name: ci" "on: [push]" "jobs:" "  test:" "    runs-on: ubuntu-latest" "    steps:" "      - run: ./test.sh"
write docs/internal/oncall.md "# On-call notes (internal only)" "" "Pager rotation, staging passwords live in the vault."
write .gitattributes "* text=auto eol=lf" "" "# Not shipped in release archives" "tests/ export-ignore" ".github/ export-ignore" "docs/internal/ export-ignore" ".gitattributes export-ignore"
as maya; commit "chore: initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "feat(cart): add removeItem"
as lena; write src/checkout.js "// Checkout" "module.exports = { checkout: (cart) => ({ ok: true }) };"
         commit "feat(checkout): add checkout"
as bot;  write VERSION "2.0.0"
         commit "chore(release): 2.0.0"
git tag -a v2.0.0 -m "Brightcart 2.0.0"
git branch release/2.0
day
as dev;  git switch -q release/2.0
         replace src/checkout.js "ok: true" "ok: cart.items.length > 0"
         commit "fix(checkout): reject empty carts"
         git switch -q main
as lena; write src/giftcards.js "// Gift cards (unreleased)" "module.exports = {};"
         commit "feat(giftcards): scaffold gift cards"
as maya; append README.md "" "Gift cards are coming in 2.1."
         commit "docs: tease gift cards"
as you
