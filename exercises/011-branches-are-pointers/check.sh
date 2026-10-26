in_repo
expect "main hasn't moved"                                        same_commit main "$(saved main)"
expect "hotfix/1.0.1 points at the v1.0 tag's commit"             same_commit hotfix/1.0.1 v1.0
expect "experiment/shipping-rules points at 'Add free-shipping threshold'" msg_is experiment/shipping-rules "Add free-shipping threshold"
expect "experiment/shipping-rules is a commit from main's history" is_ancestor experiment/shipping-rules main
expect_not "there is no branch called fixtypo anymore"            branch_exists fixtypo
expect "fix/readme-typo exists and still has the typo-fix commit" same_commit fix/readme-typo "$(saved fixtypo)"
expect "feature/wishlist starts at the tip of main"               same_commit feature/wishlist main
expect "you're on feature/wishlist"                               on_branch feature/wishlist
expect "ANSWER names the branch that is behind its upstream"      answer_is release/1.0
expect "no commits were added to any branch"                      test "$(git rev-list --count --branches --not "$(saved main)" "$(saved fixtypo)")" = 0
expect "the working tree is clean"                                clean_tree
finish
