in_repo
expect "you're on a branch (HEAD is not detached)"                  git symbolic-ref -q HEAD
expect "main is unchanged"                                          same_commit main "$(saved main)"
expect "the v1.2 tag is unchanged"                                  msg_is v1.2 "Add wishlist"
expect "hotfix/1.2.1 exists"                                        branch_exists hotfix/1.2.1
expect "hotfix/1.2.1 is based on v1.2"                              is_ancestor v1.2 hotfix/1.2.1
expect "hotfix/1.2.1 has exactly 2 commits on top of v1.2"          count_is v1.2..hotfix/1.2.1 2
expect "first: 'Add failing test for coupon expiry'"                msg_is hotfix/1.2.1~1 "Add failing test for coupon expiry"
expect "then: 'Fix coupon expiry off-by-one'"                       msg_is hotfix/1.2.1 "Fix coupon expiry off-by-one"
expect "the files are exactly what you committed this morning"      tree_is_saved hotfix/1.2.1 rescued
expect_not "the debug experiment was not rescued"                   history_has_msg "^debug:" hotfix/1.2.1
expect "the working tree is clean"                                  clean_tree
finish
