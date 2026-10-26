B=feature/order-notes
in_repo
expect "no rebase, merge or cherry-pick is in progress"            no_operation
expect "origin's $B matches your local branch"                     test "$(remote_ref origin $B)" = "$(git rev-parse -q --verify $B)"
expect "the branch is based on the latest main"                    is_ancestor "$(saved main_tip)" $B
expect "origin's main was not changed"                             test "$(remote_ref origin main)" = "$(saved main_tip)"
expect "exactly 4 commits on top of main"                          count_is "$(saved main_tip)..$B" 4
expect "Maya's 'Escape HTML in order notes' commit is on the branch" test -n "$(git log --author=maya@ --grep='^Escape HTML in order notes$' --format=%H "$(saved main_tip)..$B")"
expect "src/escape.js (Maya's fix) is in the branch"               in_commit $B src/escape.js
expect "the typo 'lenght' is gone from every commit message"       test -z "$(git log --format=%s "$(saved main_tip)..$B" | grep lenght)"
expect "'Add order note length limit' is on the branch"            history_has_msg '^Add order note length limit$' $B
expect "your other two commits are still there"                    test "$(git log --format=%s "$(saved main_tip)..$B" | grep -cE '^(Add notes field to orders|Show order notes on receipt)$')" = 2
expect "no merge commits on the branch"                            no_merges "$(saved main_tip)..$B"
expect "the working tree is clean"                                 clean_tree
finish
