# pr <branch> <number> <author> <message> <file> <line>   one commit on a branch, merged as a GitHub-style PR
pr() {
  git switch -q -c "$1"
  as "$3"; append "$5" "$6"; commit "$4"
  git switch -q main
  as maya; tick; git merge -q --no-ff -m "Merge pull request #$2 from brightcart/$1" "$1"
  git branch -q -D "$1"
}

new_repo repo
brightcart_skeleton
write CHANGELOG.md "# Changelog" "" "## v1.4.0" "" "### Features" "- guest checkout" "" "### Fixes" "- cart badge shows the right count"
as maya; commit "chore: initial storefront"
as dev;  append src/checkout.js "// guest checkout"; commit "feat(checkout): guest checkout"
as lena; append src/cart.js "// badge count"; commit "fix(cart): cart badge shows the right count"
as maya; git tag -a v1.4.0 -m "Release 1.4.0"

day 3
pr save-cart 40 lena "feat(cart): save cart between visits" src/cart.js "// persist cart"
as dev;  append src/price.js "// half-cent rounding"; commit "fix(price): round half-cent amounts correctly"
as bot;  append package.json "eslint 9"; commit "chore: bump eslint to 9"
pr search-pages 41 dev "feat(search)!: search API returns paginated results" src/search.js "// paginate"
pr retry 42 dev "fix(checkout): never double-charge on payment retry" src/checkout.js "// idempotency key"
as bot;  append package.json "lodash 4.17.21"; commit "chore(deps): update lodash"
pr wishlist-share 43 lena "feat(wishlist): share wishlist by link" src/wishlist.js "// share link"
as dev
append src/api.js "// v1 price endpoint removed"
tick; git add -A
git commit -q -m "feat(api): remove v1 price endpoint" -m "Clients must move to /api/v2/price." \
  -m "BREAKING CHANGE: GET /api/v1/price is gone; use /api/v2/price"
as maya; append src/cart.js "// coupon field"; commit "fix(cart): coupon field accepts lowercase codes"
as maya; git tag -a v1.5.0 -m "Release 1.5.0"

day 2
as lena; append src/giftcards.js "// gift cards"; commit "feat(giftcards): sell gift cards"
as you
