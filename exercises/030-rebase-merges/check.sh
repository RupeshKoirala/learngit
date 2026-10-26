changed_files_are() { [ "$(git diff --name-only "$1" "$2" 2>/dev/null | tr '\n' ' ')" = "$3 " ]; }
the_merge() { git rev-list --merges -1 main..feature/promo-banner; }
side_of_merge_is() { _m=$(the_merge); [ -n "$_m" ] && [ "$(git log --reverse --format=%s "$_m^1..$_m^2" | tr '\n' '|')" = "$1" ]; }

in_repo
F=feature/promo-banner; L=flat/promo-banner
expect "no rebase is in progress"                                   no_operation
expect "main still points at 'Add removeItem to cart'"              msg_is main "Add removeItem to cart"
expect "$F sits on top of the current main"                         is_ancestor main $F
expect "$F has exactly 6 commits on top of main"                    count_is main..$F 6
expect "$F contains exactly one merge commit"                       test "$(merges_in main..$F)" = 1
expect "the merge keeps its original message"                       test "$(git log --merges --format=%s main..$F)" = "Merge branch 'banner-styles' into feature/promo-banner"
expect "Lena's 2 commits are on the merge's side branch"            side_of_merge_is "Add banner color themes|Add dark-mode banner theme|"
expect "the side branch was rebased onto main as well"              is_ancestor main "$(the_merge)^2"
expect "compared to main, $F only adds the banner files"            changed_files_are main $F "src/banner-theme.js src/banner.js"
expect "the banner files are exactly as before"                     git diff --quiet "$(saved original)" $F -- src/banner.js src/banner-theme.js
expect "$L exists and sits on top of the current main"              is_ancestor main $L
expect "$L is flat: 5 commits, no merges"                           count_is main..$L 5
expect "$L has no merge commits"                                    no_merges main..$L
expect "both branches end with identical files"                     same_tree $L $F
expect "the working tree is clean"                                  clean_tree
finish
