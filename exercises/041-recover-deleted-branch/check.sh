in_repo
expect "no operation is in progress"                                  no_operation
expect "feature/wishlist exists again"                                branch_exists feature/wishlist
expect "it points at exactly its old tip, 'Document the wishlist'"     same_commit feature/wishlist "$(saved wishlist)"
expect "it has its 3 wishlist commits on top of the old main"          count_is "main..feature/wishlist" 3
expect_not "spike/try-new-router stays deleted"                        branch_exists spike/try-new-router
expect_not "feature/old-banner stays deleted"                          branch_exists feature/old-banner
expect "main hasn't moved"                                             same_commit main "$(saved main)"
finish
