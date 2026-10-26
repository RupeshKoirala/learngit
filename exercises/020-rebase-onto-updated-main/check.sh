subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
changed_files_are() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | tr '\n' ' ')" = "$3 " ]; }

in_repo
F=feature/free-shipping
expect "no rebase or merge is in progress"                       no_operation
expect "main still points at 'Format prices with thousands separators'" msg_is main "Format prices with thousands separators"
expect "$F sits on top of the current main"                      is_ancestor main $F
expect "$F has exactly your 2 commits on top of main"            count_is main..$F 2
expect "$F's history is linear (no merge commits)"               no_merges main..$F
expect "your commits keep their messages and their order"        subjects_are main..$F "Add flat-rate shipping cost|Free shipping on orders over \$50|"
expect "compared to main, $F only adds src/shipping.js"          changed_files_are main $F "src/shipping.js"
expect "src/shipping.js is exactly what you wrote"               git diff --quiet "$(saved original)" $F -- src/shipping.js
expect "compare/merge exists and is a merge commit"              is_merge compare/merge
expect "compare/merge contains your ORIGINAL (un-rebased) commits" is_ancestor "$(saved original)" compare/merge
expect "compare/merge contains the current main"                 is_ancestor main compare/merge
expect "both approaches end with identical files"                same_tree compare/merge $F
expect "the working tree is clean"                               clean_tree
finish
