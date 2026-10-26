remote_main() { remote_ref origin main; }
no_bug_on_remote() { ! git grep -q BUG "$(remote_main)" -- src; }

in_repo
R=$(remote_main)
expect "no revert/merge is in progress"                          no_operation
expect "origin/main kept all existing commits (no rewrite)"      is_ancestor "$(saved tip)" "$R"
expect "origin/main has exactly 1 new commit"                    count_is "$(saved tip)..$R" 1
expect "the new commit uses the conventional 'Revert \"…\"' message" msg_matches "$R" '^Revert "Show prices as whole dollars"'
expect "src/price.js on origin/main is back to the version before the bad commit" \
                                                                 test "$(git rev-parse "$R:src/price.js")" = "$(git rev-parse "$(saved bad)~1:src/price.js")"
expect "Lena's badges are still on origin/main"                  in_commit "$R" src/badges.js
expect "Maya's README change is still on origin/main"            rev_file_has "$R" README.md "deploy schedule|Deploys go out"
expect "no BUG marker left in src/ on origin/main"               no_bug_on_remote
expect "your local main matches origin/main"                     same_commit main "$R"
expect "the working tree is clean"                               clean_tree
finish
