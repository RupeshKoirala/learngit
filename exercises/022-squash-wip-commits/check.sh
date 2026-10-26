in_repo
expect "no rebase is in progress"                          no_operation
expect "you're on feature/discount-codes"                   on_branch feature/discount-codes
expect "main still points at 'Add removeItem to cart'"      msg_is main "Add removeItem to cart"
expect "the branch has exactly 2 commits on top of main"    count_is main..feature/discount-codes 2
expect "the branch is based on the tip of main"             is_ancestor main feature/discount-codes
expect "first commit is 'Add discount code support'"        msg_is feature/discount-codes~1 "Add discount code support"
expect "second commit is 'Document discount codes'"         msg_is feature/discount-codes "Document discount codes"
expect "the code commit only touches src/discount.js"       test "$(git diff --name-only feature/discount-codes~2 feature/discount-codes~1)" = "src/discount.js"
expect "the final files are exactly what you had before"    tree_is_saved feature/discount-codes original
expect "the working tree is clean"                          clean_tree
finish
