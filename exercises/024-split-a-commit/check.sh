subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
touches()      { [ "$(git diff-tree --no-commit-id --name-only -r "$1" 2>/dev/null | tr '\n' ' ')" = "$2 " ]; }

in_repo
F=feature/reviews
expect "no rebase is in progress"                                  no_operation
expect "you're on $F"                                              on_branch $F
expect "main still points at 'Initial storefront'"                 msg_is main "Initial storefront"
expect "$F is based on main"                                       is_ancestor main $F
expect "$F has exactly 4 commits on top of main"                   count_is main..$F 4
expect "commits are: model, fix, widget, product page (in order)"  subjects_are main..$F "Add product reviews model|Fix price rounding for fractional cents|Add star rating widget|Show average rating on product page|"
expect "'Add product reviews model' only touches src/reviews.js"   touches $F~3 "src/reviews.js"
expect "the fix commit only touches src/price.js"                  touches $F~2 "src/price.js"
expect "the widget commit only touches src/rating.js"              touches $F~1 "src/rating.js"
expect "'Show average rating…' only touches src/product-page.js"   touches $F "src/product-page.js"
expect "the final files are exactly what you had before"           tree_is_saved $F original
expect "the working tree is clean"                                 clean_tree
finish
