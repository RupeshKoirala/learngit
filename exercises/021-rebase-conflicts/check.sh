subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
no_markers_in() { ! git grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$1" -- . 2>/dev/null; }

in_repo
F=feature/currency
expect "no rebase is in progress"                                   no_operation
expect "you're on $F"                                               on_branch $F
expect "main still points at 'Show refunds as negative prices'"     msg_is main "Show refunds as negative prices"
expect "$F sits on top of the current main"                         is_ancestor main $F
expect "$F has exactly 2 commits on top of main"                    count_is main..$F 2
expect "they are the currency commits, in their original order"     subjects_are main..$F "Support a currency symbol in formatPrice|Show the order total in the shop's currency|"
expect "your duplicate empty-cart fix is gone (cart.js = main's)"   git diff --quiet main $F -- src/cart.js
expect "no conflict markers are committed"                          no_markers_in $F
expect "formatPrice still takes a currency symbol"                  rev_file_has $F src/price.js "formatPrice\(cents, *symbol"
expect "formatPrice still handles negative amounts (Lena's change)"  rev_file_has $F src/price.js "Math\.abs\(cents\)"
expect "formatPrice returns sign + symbol + amount"                 rev_file_has $F src/price.js "return +sign *\+ *symbol *\+"
expect "src/summary.js is unchanged"                                git diff --quiet "$(saved original)" $F -- src/summary.js
expect "the working tree is clean"                                  clean_tree
finish
