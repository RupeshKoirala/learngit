EXPECTED="// Price formatting
function formatPrice(cents, currency = 'USD') {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(cents / 100);
}

module.exports = { formatPrice };"
B=feature/multi-currency
price_is_resolved() { [ "$(git show "$B:src/price.js" 2>/dev/null)" = "$EXPECTED" ]; }
rerere_recorded() {
  _d="$(git rev-parse --git-dir)/rr-cache"
  [ -d "$_d" ] && grep -lq "currency = 'USD'" "$_d"/*/postimage 2>/dev/null
}
subjects() { git log --reverse --format=%s "main..$B" | tr '\n' '|'; }

in_repo
expect "no merge or rebase is in progress"                    no_operation
expect "rerere recorded your resolution (.git/rr-cache)"      rerere_recorded
expect "main hasn't changed"                                  same_commit main "$(saved main)"
expect "$B is on top of main"                                 is_ancestor main $B
expect "$B has no merge commits"                              no_merges main..$B
expect "$B still has its 3 commits, same messages and order"  test "$(subjects)" = "feat(price): accept a currency code|feat(cart): add totalIn for multi-currency carts|docs: mention multi-currency prices|"
expect "src/price.js is exactly the agreed resolution"        price_is_resolved
expect "src/cart.js has both totalIn and the tax TODO"        sh -c "git show $B:src/cart.js | grep -q totalIn && git show $B:src/cart.js | grep -q 'tax per region'"
expect "no conflict markers anywhere"                         no_conflict_markers
expect "the working tree is clean"                            clean_tree
finish
