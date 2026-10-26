in_repo
R=$(remote_ref origin main)
expect "no revert/merge is in progress"                                 no_operation
expect "origin/main kept all existing commits (no rewrite)"             is_ancestor "$(saved tip)" "$R"
expect "origin/main has exactly 1 new commit"                           count_is "$(saved tip)..$R" 1
expect "the new commit is a normal (non-merge) commit"                  test "$(git rev-list --merges --count "$(saved tip)..$R")" = 0
expect "it uses the default message 'Revert \"Merge branch 'feature/gift-cards'\"'" \
                                                                        msg_matches "$R" "^Revert \"Merge branch 'feature/gift-cards'\""
expect "the gift-card code is gone from origin/main"                    test -z "$(git ls-tree "$R" src/giftcard.js)"
expect "src/ on origin/main is exactly main's side before the merge"    git diff --quiet "$(saved merge)^1" "$R" -- src
expect "Dev's shipping rules survived"                                  in_commit "$R" src/shipping.js
expect "Dev's README commit after the merge survived"                   rev_file_has "$R" README.md "help@brightcart"
expect "feature/gift-cards on origin is untouched"                      test "$(remote_ref origin feature/gift-cards)" = "$(saved feature)"
expect "your local main matches origin/main"                            same_commit main "$R"
expect "the working tree is clean"                                      clean_tree
finish
