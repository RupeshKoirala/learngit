in_repo
expect "you're on main"                                        on_branch main
expect "Dev's commit is directly below yours"                  same_commit HEAD^ "$(saved dev)"
expect "your commit is 'Fix formatPrice rounding'"             msg_is HEAD "Fix formatPrice rounding"
expect "…and it only touches src/price.js"                     test "$(git diff --name-only HEAD^ HEAD)" = "src/price.js"
expect "…with the rounding fix"                                rev_file_has HEAD src/price.js 'Math\.round\(cents\)'
expect "the cart work is not committed"                        sh -c "[ \$(git rev-parse HEAD:src/cart.js) = \$(git rev-parse $(saved dev):src/cart.js) ]"
expect "nothing is left in a conflicted state"                 test -z "$(git diff --name-only --diff-filter=U)"
expect "src/cart.js has no conflict markers"                   file_lacks src/cart.js '^(<<<<<<<|=======|>>>>>>>)'
expect "total() keeps Dev's empty-cart early return"           file_has src/cart.js 'if \(!cart\.items\.length\) return 0;'
expect "total() keeps your bulkDiscount call"                  file_has src/cart.js 'return bulkDiscount\(sum, cart\.items\.length\);'
expect "your bulkDiscount function is still there"             file_has src/cart.js '^function bulkDiscount'
expect "the stash list is empty"                               test -z "$(git stash list)"
expect "no other files are modified"                           test -z "$(git status --porcelain | grep -v ' src/cart.js$')"
finish
