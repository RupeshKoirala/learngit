in_repo
expect "no merge or cherry-pick in progress"                      no_operation
expect "main is unchanged"                                        same_commit main "$(saved main)"
expect "branch feature/loyalty-points exists"                     branch_exists feature/loyalty-points
expect "it starts at 'Add checkout' (the stash's base commit)"    same_commit feature/loyalty-points^ "$(saved base)"
expect "it has one commit 'Add loyalty points to checkout'"       msg_is feature/loyalty-points "Add loyalty points to checkout"
expect "the commit contains src/loyalty.js"                       in_commit feature/loyalty-points src/loyalty.js
expect "the commit contains exactly the stashed work"             tree_is_saved feature/loyalty-points loyalty
expect "the loyalty stash is gone from the list"                  sh -c "! git stash list | grep -q loyalty"
expect "the dark-mode experiment is still stashed"                sh -c "git stash list | grep -q 'experiment: dark mode'"
expect "the working tree is clean"                                clean_tree
finish
