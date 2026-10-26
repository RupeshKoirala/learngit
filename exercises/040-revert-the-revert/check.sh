in_repo
R=$(remote_ref origin main)
expect "no merge/revert is in progress"                                   no_operation
expect "origin/main kept all existing commits (no rewrite)"               is_ancestor "$(saved tip)" "$R"
expect "feature/gift-cards (with Lena's fix) is merged into origin/main"  is_ancestor "$(saved feature)" "$R"
expect "src/giftcard.js is back on origin/main"                           in_commit "$R" src/giftcard.js
expect "giftcard.js and cart.js on origin/main match the fixed branch"     git diff --quiet "$(saved feature)" "$R" -- src/giftcard.js src/cart.js
expect "Dev's shipping rules are untouched"                               git diff --quiet "$(saved tip)" "$R" -- src/shipping.js src/price.js
expect "no BUG marker in src/ on origin/main"                             test -z "$(git grep -l BUG "$R" -- src)"
expect "Dev's and Sam's README lines are still there"                     rev_file_has "$R" README.md "Holiday sale"
expect "…including Dev's support address"                                 rev_file_has "$R" README.md "help@brightcart"
expect "your local main matches origin/main"                              same_commit main "$R"
expect "no conflict markers anywhere"                                     no_conflict_markers
expect "the working tree is clean"                                        clean_tree
finish
