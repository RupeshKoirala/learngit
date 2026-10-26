in_repo
start=$(saved start)
commit_titled() { git log --format='%H %s' "$start..HEAD" 2>/dev/null | while read -r h s; do [ "$s" = "$1" ] && echo "$h" && break; done; }
files_of()      { git diff-tree --no-commit-id --name-only -r "$1" | sort | tr '\n' ' '; }
commit_has_files() { _c=$(commit_titled "$1"); [ -n "$_c" ] && [ "$(files_of "$_c")" = "$2" ]; }
untracked_only_notes() { [ "$(git status --porcelain)" = "?? notes.txt" ]; }

expect "you're on main"                                         on_branch main
expect "main still starts from 'Leave a TODO for removeItem'"   is_ancestor "$start" HEAD
expect "there are exactly 2 new commits"                        count_is "$start..HEAD" 2
expect "'Fix rounding in formatPrice' contains only src/price.js"        commit_has_files "Fix rounding in formatPrice" "src/price.js "
expect "'Add removeItem to cart' contains src/cart.js and README.md"     commit_has_files "Add removeItem to cart" "README.md src/cart.js "
expect "the committed files are exactly your edits (nothing changed or lost)" tree_is_saved HEAD target
expect "notes.txt still exists"                                 test -f notes.txt
expect "notes.txt was never committed"                          history_lacks_path notes.txt
expect "nothing is staged or modified; only notes.txt is untracked"  untracked_only_notes
finish
