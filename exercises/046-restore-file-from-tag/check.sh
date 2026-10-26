rev_file_lacks_wip() { ! git show main:src/cart.js | grep -q bulkDiscount; }

in_repo
expect "no operation is in progress"                               no_operation
expect "you're on main"                                            on_branch main
expect "history wasn't rewritten"                                  is_ancestor "$(saved main)" main
expect "exactly 1 new commit on main"                              count_is "$(saved main)..main" 1
expect "it's called 'Restore v1.2.0 price formatting'"             msg_is main "Restore v1.2.0 price formatting"
expect "src/price.js in that commit is exactly the v1.2.0 version" test "$(git rev-parse main:src/price.js)" = "$(git rev-parse v1.2.0:src/price.js)"
expect "the commit changes nothing but src/price.js"               test "$(git diff --name-only "$(saved main)" main)" = "src/price.js"
expect "Lena's itemCount is still committed"                       rev_file_has main src/cart.js "function itemCount"
expect "your bulk-discount WIP is still in src/cart.js"            file_has src/cart.js "bulkDiscount"
expect "…and it is not committed"                                  rev_file_lacks_wip
expect "tag v1.2.0 still points at 'Add removeItem to cart'"       msg_is v1.2.0 "Add removeItem to cart"
expect "tag v1.3.0 still points at 'Mention the changelog'"        same_commit v1.3.0 "$(saved main)"
finish
