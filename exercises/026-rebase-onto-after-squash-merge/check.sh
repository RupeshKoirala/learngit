subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
changed_files_are() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | tr '\n' ' ')" = "$3 " ]; }

in_repo
F=feature/search-ui
expect "no rebase is in progress"                                   no_operation
expect "main still points at 'Add support email to README'"         msg_is main "Add support email to README"
expect "$F sits on top of the current main"                         is_ancestor main $F
expect "$F has exactly 2 commits on top of main"                    count_is main..$F 2
expect "they're your two commits, in order"                         subjects_are main..$F "Add search box component|Debounce search box input|"
expect "none of Dev's commits are replayed on your branch"          test -z "$(git log --format=%ae main..$F | grep dev@brightcart)"
expect "compared to main, $F only adds src/search-ui.js"            changed_files_are main $F "src/search-ui.js"
expect "src/search-ui.js is exactly what you wrote"                 git diff --quiet "$(saved original)" $F -- src/search-ui.js
expect "the working tree is clean"                                  clean_tree
finish
