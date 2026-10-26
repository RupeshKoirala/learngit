grows_by() { git merge-base --is-ancestor "$(saved "$1")" "$2" && [ "$(git rev-list --count "$(saved "$1")..$2")" = "$3" ]; }

in_repo
expect "no cherry-pick is in progress"                            no_operation
expect "main is unchanged"                                        same_commit main "$(saved main)"
expect "lena/wishlist is unchanged"                               same_commit lena/wishlist "$(saved wish)"
expect "release/2.4 has exactly one new commit"                   grows_by release release/2.4 1
expect "…and it is an ordinary commit, not a merge"               sh -c "! git rev-parse -q --verify release/2.4^2 >/dev/null"
expect "its subject is 'Add wishlist (backport of PR #42)'"       msg_is release/2.4 "Add wishlist (backport of PR #42)"
expect "its message says '(cherry picked from commit <merge>)'"   sh -c "git log -1 --format=%B release/2.4 | grep -qF '(cherry picked from commit $(saved merge))'"
expect "release/2.4 has the wishlist code and button"             sh -c "git cat-file -e release/2.4:src/wishlist.js && git show release/2.4:templates/product.html | grep -q wishlist"
expect "the experimental recommendations engine stayed out"       sh -c "! git cat-file -e release/2.4:src/recommend.js"
expect "exactly PR #42's changes were added (nothing else)"       tree_is_saved release/2.4 expected
expect "the working tree is clean"                                clean_tree
finish
