rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
in_repo
expect "no rebase or merge is in progress"                            no_operation
expect "main was fast-forwarded to the server's main"                 same_commit main "$(saved main_tip)"
expect "main has no merge commits"                                    no_merges main
expect "feature/reviews contains Lena's commit"                       is_ancestor "$(saved lena_tip)" feature/reviews
expect "feature/reviews: your 2 commits sit on top of Lena's (linear)" sh -c "git merge-base --is-ancestor $(saved lena_tip) feature/reviews && [ \"\$(git rev-list --count $(saved lena_tip)..feature/reviews)\" = 2 ] && [ \"\$(git rev-list --merges --count $(saved lena_tip)..feature/reviews)\" = 0 ]"
expect "feature/reviews is pushed"                                    test "$(remote_ref origin feature/reviews)" = "$(git rev-parse feature/reviews)"
expect "release/2.5 contains Dev's hotfix"                            is_ancestor "$(saved hotfix)" release/2.5
expect "release/2.5 still contains the exact commit QA tested"        is_ancestor "$(saved rc1)" release/2.5
expect "tag v2.5.1-rc1 is unchanged (locally and on the server)"      sh -c "[ \"\$(git rev-parse v2.5.1-rc1^{commit})\" = $(saved rc1) ] && [ \"\$(git --git-dir='$LG_DIR/remotes/origin.git' rev-parse v2.5.1-rc1^{commit})\" = $(saved rc1) ]"
expect "release/2.5 is pushed"                                        test "$(remote_ref origin release/2.5)" = "$(git rev-parse release/2.5)"
expect "repo config: pull.rebase = true"                              test "$(git config --local --get pull.rebase)" = true
expect "repo config: release/2.5 pulls with merge (branch.release/2.5.rebase = false)" test "$(git config --local --get branch.release/2.5.rebase)" = false
expect "the working tree is clean"                                    clean_tree
finish
