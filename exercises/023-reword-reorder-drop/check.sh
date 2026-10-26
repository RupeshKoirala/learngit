subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
touches()      { [ "$(git diff-tree --no-commit-id --name-only -r "$1" 2>/dev/null | tr '\n' ' ')" = "$2 " ]; }
changed_files_are() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | tr '\n' ' ')" = "$3 " ]; }

in_repo
F=feature/wishlist
expect "no rebase is in progress"                             no_operation
expect "main still points at 'Initial storefront'"            msg_is main "Initial storefront"
expect "$F is based on main"                                  is_ancestor main $F
expect "$F has exactly 3 commits on top of main"              count_is main..$F 3
expect "messages are: module, button, docs (in that order)"   subjects_are main..$F "Add wishlist module|Add wishlist button to product page|Document the wishlist|"
expect "'Add wishlist module' only touches src/wishlist.js"   touches $F~2 "src/wishlist.js"
expect "'Add wishlist button…' only touches src/product-page.js" touches $F~1 "src/product-page.js"
expect "'Document the wishlist' only touches README.md"       touches $F "README.md"
expect "src/debug.js is in no commit of the branch"           test -z "$(git log --format=%H main..$F -- src/debug.js)"
expect "all other files are exactly as before"                changed_files_are "$(saved original)" $F "src/debug.js"
expect "the working tree is clean"                            clean_tree
finish
