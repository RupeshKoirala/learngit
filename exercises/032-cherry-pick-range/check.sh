pid() { git show "$1" 2>/dev/null | git patch-id --stable | cut -d' ' -f1; }
same_change() { [ -n "$(pid "$1")" ] && [ "$(pid "$1")" = "$(pid "$2")" ]; }
a11y() { git log --format=%H --grep='^a11y:' "$(saved redesign)" | sed -n "${1}p"; }   # 1 = newest
grows_by() { git merge-base --is-ancestor "$(saved "$1")" "$2" && [ "$(git rev-list --count "$(saved "$1")..$2")" = "$3" ]; }

in_repo
expect "no cherry-pick is in progress"                          no_operation
expect "feature/checkout-redesign is untouched"                 same_commit feature/checkout-redesign "$(saved redesign)"
expect "release/2.0 has exactly 3 new commits"                  grows_by release release/2.0 3
expect "release/2.0~2 is a copy of 'a11y: add alt text to cart image'"      same_change release/2.0~2 "$(a11y 3)"
expect "release/2.0~1 is a copy of 'a11y: label the remove-item button'"    same_change release/2.0~1 "$(a11y 2)"
expect "release/2.0 tip is a copy of 'a11y: visible focus outline'"         same_change release/2.0 "$(a11y 1)"
expect "the release copies keep their original messages"        sh -c "git log -3 --format=%s release/2.0 | grep -c '^a11y:' | grep -qx 3"
expect "release/2.0 has the fixes and nothing else"             tree_is_saved release/2.0 release_expected
expect "main has exactly 1 new commit"                          grows_by main main 1
expect "it's named 'Accessibility fixes for checkout audit'"    msg_is main "Accessibility fixes for checkout audit"
expect "main has all three fixes and nothing else"              tree_is_saved main main_expected
expect "no redesign CSS reached either branch"                  sh -c "! git cat-file -e main:styles/redesign.css && ! git cat-file -e release/2.0:styles/redesign.css"
expect "the working tree is clean"                              clean_tree
finish
