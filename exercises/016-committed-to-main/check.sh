in_repo
expect "no operation is in progress"                              no_operation
expect "you're on feature/wishlist"                               on_branch feature/wishlist
expect "feature/wishlist holds your 3 commits, unchanged"         same_commit feature/wishlist "$(saved wishlist)"
expect "the server's main was not changed (nothing pushed)"       test "$(remote_ref origin main)" = "$(saved remote_main)"
expect "local main matches main on the server (you fetched)"      same_commit main "$(saved remote_main)"
expect_not "main no longer contains the wishlist commits"         is_ancestor "$(saved wishlist)" main
expect "main still tracks origin/main"                            test "$(upstream_of main)" = "origin/main"
expect "removeFromWishlist is still in your working tree"         file_has src/wishlist.js "function removeFromWishlist"
expect "...and still uncommitted"                                 eval "! git diff --quiet HEAD -- src/wishlist.js"
expect "nothing else is dirty"                                    test "$(git status --porcelain | grep -v ' src/wishlist.js$' | grep -c .)" = 0
finish
