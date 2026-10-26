methods_line() { git show feature/gift-cards:src/checkout.js 2>/dev/null | grep 'PAYMENT_METHODS *='; }
has_method()   { methods_line | grep -qE "[\"']$1[\"']"; }

in_repo
expect "no merge is in progress"                               no_operation
expect "you're on feature/gift-cards"                          on_branch feature/gift-cards
expect "main is unchanged"                                     same_commit main "$(saved main)"
expect "your branch ends with a merge commit"                  is_merge feature/gift-cards
expect "...whose parents are your old tip and main"            test "$(git rev-parse feature/gift-cards^1 feature/gift-cards^2 2>/dev/null)" = "$(printf '%s\n' "$(saved feature)" "$(saved main)")"
expect "no conflict markers are left anywhere"                 no_conflict_markers
expect "PAYMENT_METHODS is declared exactly once"              test "$(git show feature/gift-cards:src/checkout.js | grep -c 'PAYMENT_METHODS *=')" = 1
expect "PAYMENT_METHODS still has card and paypal"             eval "has_method card && has_method paypal"
expect "PAYMENT_METHODS has applepay (Lena's intent)"          has_method applepay
expect "PAYMENT_METHODS has giftcard (your intent)"            has_method giftcard
expect "the banner line wasn't touched"                        rev_file_has feature/gift-cards src/checkout.js "^const CHECKOUT_BANNER = 'Free shipping on orders over \\\$50';$"
expect "both new files made it: giftcard.js and applepay.js"   eval "in_commit HEAD src/giftcard.js && in_commit HEAD src/applepay.js"
expect "the working tree is clean"                             clean_tree
finish
