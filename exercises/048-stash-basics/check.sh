stash_named() { git stash list --format='%gd %gs' | grep -F -- "$1" | head -1 | cut -d' ' -f1; }
has_stash() { [ -n "$(stash_named "$1")" ]; }
R=$( cd "$LG_DIR/repo" && stash_named "search: half-done ranking" )

in_repo
expect "ANSWER names the file the unnamed stash changes"          answer_is src/payment.js
expect "you're still on feature/search, no new commits"           sh -c "[ \$(git symbolic-ref --short HEAD) = feature/search ] && [ \$(git rev-parse HEAD) = $(saved head) ]"
expect "a stash named 'search: half-done ranking' exists"         has_stash "search: half-done ranking"
expect "…it holds your ranking change to src/search.js"           sh -c "[ -n '$R' ] && git show '$R:src/search.js' | grep -q rankResults"
expect "…and the untracked src/search-ui.js (stashed with -u)"    sh -c "[ -n '$R' ] && git cat-file -e '$R^3:src/search-ui.js'"
expect "the fuzzy experiment is still in the stash list"          has_stash "experiment: fuzzy matching"
expect "the old unnamed WIP stash was dropped"                    sh -c "! git stash list | grep -q 'WIP on'"
expect "exactly 2 stashes remain"                                 test "$(git stash list | wc -l | tr -d ' ')" = 2
expect "your working tree shows the fuzzy experiment"             file_has src/search.js levenshtein
expect "…and not the ranking work (it's in the stash)"            file_lacks src/search.js rankResults
expect "src/search-ui.js is not lying around in the working tree" test ! -e src/search-ui.js
finish
