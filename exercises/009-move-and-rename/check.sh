in_repo
start=$(saved start)
renames() { git diff -M --name-status "$start" "$start_next" | sort | tr '\t' ' ' | tr '\n' '|'; }
start_next=$(git rev-list --reverse "$start..HEAD" 2>/dev/null | head -1)
want="R100 src/cart.js src/cart/cart.js|R100 src/price.js src/utils/format-price.js|R100 test.sh scripts/test.sh|"
pure_move()   { [ -n "$start_next" ] && [ "$(renames)" = "$want" ]; }
readme_only() { [ "$(git diff --name-only HEAD~1 HEAD)" = "README.md" ]; }
executable()  { [ "$(git ls-tree HEAD scripts/test.sh | cut -c1-6)" = "100755" ]; }
follow_ok()   { [ "$(git log --follow --format=%H -- src/utils/format-price.js | tail -1)" = "$(saved price_created)" ]; }

expect "you're on main, building on the existing history"           is_ancestor "$start" HEAD
expect "there are exactly 2 new commits"                            count_is "$start..HEAD" 2
expect "the first new commit only moves the 3 files (100% renames)" pure_move
expect "the second new commit only changes README.md"               readme_only
expect "README.md says ./scripts/test.sh"                           rev_file_has HEAD README.md '\./scripts/test\.sh'
expect "README.md no longer says ./test.sh"                         eval '! git show HEAD:README.md | grep -qE "(^|[^a-z])\./test\.sh"'
expect "scripts/test.sh is still executable"                        executable
expect "git log --follow finds the file's whole history"            follow_ok
expect "ANSWER holds the commit that created the price file"        answer_commit_is "$(saved price_created)"
expect "the working tree is clean"                                  clean_tree
finish
