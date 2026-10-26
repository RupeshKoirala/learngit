same_blob() { [ "$(git rev-parse "$1" 2>/dev/null)" = "$(git rev-parse "$2" 2>/dev/null)" ] && [ -n "$(git rev-parse "$1" 2>/dev/null)" ]; }

in_repo
W=$(saved wrong)
expect "no cherry-pick/rebase is in progress"                        no_operation
expect "main is unchanged"                                           same_commit main "$(saved main)"
expect "feature/search-filters ends at 'Add brand filter' again"     same_commit feature/search-filters "$(saved search)"
expect "feature/wishlist still starts with your original 'Add wishlist store'" same_commit feature/wishlist~2 "$(saved wishlist)"
expect "feature/wishlist has 3 commits on top of main"               count_is main..feature/wishlist 3
expect "commit 2 on wishlist is 'Add wishlist heart button'"         msg_is feature/wishlist~1 "Add wishlist heart button"
expect "commit 3 on wishlist is 'Show wishlist count badge'"         msg_is feature/wishlist "Show wishlist count badge"
expect "the heart button file is identical to what you wrote"        same_blob feature/wishlist~1:src/wishlist-button.js "$W~1:src/wishlist-button.js"
expect "the badge version is identical to what you wrote"            same_blob feature/wishlist:src/wishlist-button.js "$W:src/wishlist-button.js"
expect_not "no search code leaked into feature/wishlist"             in_commit feature/wishlist src/search.js
expect_not "no wishlist code left on feature/search-filters"         in_commit feature/search-filters src/wishlist-button.js
expect "the working tree is clean"                                   clean_tree
finish
