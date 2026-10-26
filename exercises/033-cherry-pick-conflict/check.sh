grows_by() { git merge-base --is-ancestor "$(saved "$1")" "$2" && [ "$(git rev-list --count "$(saved "$1")..$2")" = "$3" ]; }

in_repo
expect "no cherry-pick is in progress"                          no_operation
expect "you're on main"                                         on_branch main
expect "release/3.1 is untouched"                               same_commit release/3.1 "$(saved release)"
expect "main has exactly 2 new commits"                         grows_by main main 2
expect "main~1 is 'Fix total() for items without a qty'"        msg_is main~1 "Fix total() for items without a qty"
expect "main is 'Fix formatPrice for negative amounts'"         msg_is main "Fix formatPrice for negative amounts"
expect "VERSION on main is still 3.2.0-dev"                     test "$(git show main:VERSION)" = "3.2.0-dev"
expect "Lena's lineTotal() refactor is kept"                    rev_file_has main src/cart.js 'map\(lineTotal\)'
expect "the qty fix lives in lineTotal()"                       rev_file_has main src/cart.js 'return item\.price \* \(?item\.qty *(\|\||\?\?) *1\)?;'
expect "there is exactly one total() function"              sh -c "[ \$(git show main:src/cart.js | grep -c '^function total') = 1 ]"
expect "the old pre-refactor reduce line didn't come back"      sh -c "! git show main:src/cart.js | grep -q 'i\.price'"
expect "the negative-price fix is on main"                      rev_file_has main src/price.js 'Math\.abs\(cents\)'
expect "no conflict markers anywhere"                           no_conflict_markers
expect "the working tree is clean"                              clean_tree
finish
