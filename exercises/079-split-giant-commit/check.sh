files_between() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | sort | tr '\n' ' ')" = "$3" ]; }

in_repo
expect "no operation is in progress"                           no_operation
expect "main hasn't moved"                                     same_commit main "$(saved main)"
expect "feature/tax exists and is based on main"               eval 'branch_exists feature/tax && is_ancestor main feature/tax'
expect "feature/shipping exists and is based on feature/tax"   eval 'branch_exists feature/shipping && is_ancestor feature/tax feature/shipping'
expect "feature/checkout-ui exists and is based on feature/shipping" eval 'branch_exists feature/checkout-ui && is_ancestor feature/shipping feature/checkout-ui'
expect "each branch adds at least one commit"                  eval '! same_commit main feature/tax && ! same_commit feature/tax feature/shipping && ! same_commit feature/shipping feature/checkout-ui'
expect "no merge commits in the stack"                         no_merges main..feature/checkout-ui
expect "feature/tax adds only src/tax.js and src/tax-rates.js" files_between main feature/tax "src/tax-rates.js src/tax.js "
expect "feature/shipping adds only the two shipping files"     files_between feature/tax feature/shipping "src/shipping-zones.js src/shipping.js "
expect "feature/checkout-ui changes only checkout-ui.js, cart.js, README.md" files_between feature/shipping feature/checkout-ui "README.md src/cart.js src/checkout-ui.js "
expect "the top of the stack has exactly the giant commit's files" tree_is_saved feature/checkout-ui big
expect "the working tree is clean"                             clean_tree
finish
