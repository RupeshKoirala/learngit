subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
touches()      { [ "$(git diff-tree --no-commit-id --name-only -r "$1" 2>/dev/null | tr '\n' ' ')" = "$2 " ]; }
no_fixups()    { ! git log --format=%s "$1" | grep -qE '^(fixup|squash|amend)! '; }

in_repo
F=feature/gift-cards
expect "no rebase is in progress"                                       no_operation
expect "you're on $F"                                                   on_branch $F
expect "main still points at 'Initial storefront'"                      msg_is main "Initial storefront"
expect "$F is based on main"                                            is_ancestor main $F
expect "$F has exactly 3 commits on top of main"                        count_is main..$F 3
expect "no fixup!/squash! commits are left"                             no_fixups main..$F
expect "the three original messages are kept, in order"                 subjects_are main..$F "Add gift card model|Redeem gift cards at checkout|Document gift cards|"
expect "'Add gift card model' itself has the 16-character fix"          rev_file_has $F~2 src/giftcard.js "\{16\}"
expect "'Add gift card model' only touches src/giftcard.js"             touches $F~2 "src/giftcard.js"
expect "'Redeem gift cards…' itself has the balance check"              rev_file_has $F~1 src/checkout.js "amount > card\.balance"
expect "'Redeem gift cards…' only touches src/checkout.js"              touches $F~1 "src/checkout.js"
expect "'Document gift cards' only touches README.md"                   touches $F "README.md"
expect "the final files are exactly your fixed working tree"            tree_is_saved $F fixed
expect "rebase.autoSquash is turned on for this repository"             test "$(git config --local --bool rebase.autoSquash)" = true
expect "the working tree is clean"                                      clean_tree
finish
