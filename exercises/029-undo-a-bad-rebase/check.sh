subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
no_markers_in() { ! git grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$1" -- . 2>/dev/null; }

in_repo
F=feature/returns
expect "tag before-rebase points at your original, pre-rebase tip"   same_commit before-rebase "$(saved original)"
expect "no rebase is in progress"                                    no_operation
expect "main still points at 'Document shipping times'"              msg_is main "Document shipping times"
expect "$F sits on top of the current main"                          is_ancestor main $F
expect "$F has exactly 3 commits on top of main"                     count_is main..$F 3
expect "all 3 of your commits are back, in their original order"     subjects_are main..$F "Add returns policy module|Extend the return window to 30 days|Charge a restocking fee for opened items|"
expect "the return window is 30 days again"                          rev_file_has $F src/returns.js "RETURN_WINDOW_DAYS = 30;"
expect "README keeps Lena's shipping line"                           rev_file_has $F README.md "^Shipping: orders ship within 2 business days\.$"
expect "README has your returns line"                                rev_file_has $F README.md "^Returns: accepted within 30 days of delivery\.$"
expect "no conflict markers are committed"                           no_markers_in $F
expect "src/fees.js is unchanged"                                    git diff --quiet "$(saved original)" $F -- src/fees.js
expect "the working tree is clean"                                   clean_tree
finish
