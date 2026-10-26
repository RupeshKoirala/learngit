pid() { git show "$1" 2>/dev/null | git patch-id --stable | cut -d' ' -f1; }
same_change() { [ -n "$(pid "$1")" ] && [ "$(pid "$1")" = "$(pid "$2")" ]; }
grows_by() { git merge-base --is-ancestor "$(saved "$1")" "$2" && [ "$(git rev-list --count "$(saved "$1")..$2")" = "$3" ]; }
no_missing_fixes() { ! git cherry -v release/2.x "$(saved main)" | grep -qE '^\+ [0-9a-f]+ fix:'; }

in_repo
expect "ANSWER names the oldest release with the CA tax fix"     answer_is v2.0.2
expect "no cherry-pick is in progress"                           no_operation
expect "main is unchanged"                                       same_commit main "$(saved main)"
expect "release/2.x has exactly one new commit"                  grows_by release release/2.x 1
expect "it is the same change as 'fix: cart badge count off by one'" same_change release/2.x "$(saved f_badge)"
expect "its message has '(cherry picked from commit <fix>)'"     sh -c "git log -1 --format=%B release/2.x | grep -qF '(cherry picked from commit $(saved f_badge))'"
expect "git cherry finds no missing fix: on release/2.x"         no_missing_fixes
expect "tag v2.0.3 points at release/2.x"                        same_commit v2.0.3 release/2.x
expect "the old tags didn't move"                                sh -c "[ \$(git rev-parse v2.0.2^{commit}) = $(saved release) ]"
expect "no features leaked into release/2.x"                     sh -c "! git cat-file -e release/2.x:src/giftcard.js && ! git cat-file -e release/2.x:styles/dark.css && ! git cat-file -e release/2.x:src/wishlist.js"
expect "the working tree is clean"                               clean_tree
finish
