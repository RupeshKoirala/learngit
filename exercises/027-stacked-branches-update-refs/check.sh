subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
changed_files_are() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | tr '\n' ' ')" = "$3 " ]; }

in_repo
B1=feature/checkout-1-model; B2=feature/checkout-2-api; B3=feature/checkout-3-ui
expect "no rebase is in progress"                              no_operation
expect "main still points at 'Add removeItem to cart'"         msg_is main "Add removeItem to cart"
expect "$B1 sits on top of the current main"                   is_ancestor main $B1
expect "$B2 builds on the new $B1"                             is_ancestor $B1 $B2
expect "$B3 builds on the new $B2"                             is_ancestor $B2 $B3
expect "$B1 = main + 2 commits (model, validation)"            subjects_are main..$B1 "Add Order model|Validate order addresses|"
expect "$B2 = $B1 + 1 commit (endpoint)"                       subjects_are $B1..$B2 "Add POST /orders endpoint|"
expect "$B3 = $B2 + 2 commits (page, confirmation)"            subjects_are $B2..$B3 "Add checkout page|Show order confirmation|"
expect "no branch still contains the old, pre-rebase commits"  test -z "$(git branch --contains "$(saved s1)" 2>/dev/null)"
expect "$B1 only adds src/order.js"                            changed_files_are main $B1 "src/order.js"
expect "$B2 only adds src/order-api.js"                        changed_files_are $B1 $B2 "src/order-api.js"
expect "$B3 only adds src/checkout-page.js"                    changed_files_are $B2 $B3 "src/checkout-page.js"
expect "the stack's files are exactly as before"               git diff --quiet "$(saved s3)" $B3 -- src/order.js src/order-api.js src/checkout-page.js
expect "the working tree is clean"                             clean_tree
finish
