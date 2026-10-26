in_repo
ans() { [ -f "$LG_DIR/ANSWER" ] && sed -n "s/^[[:space:]]*$1[[:space:]]*[=:][[:space:]]*//p" "$LG_DIR/ANSWER" | head -1 | tr -d ' \r\t`"' | tr 'A-Z' 'a-z'; }
q1_ok() { a=$(ans q1); [ "$a" = "src/price.js" ] || [ "$a" = "price.js" ]; }
q2_ok() { [ "$(ans q2)" = "contiguous" ]; }
q3_ok() { [ "$(ans q3)" = "3" ]; }
q4_ok() { [ -n "$(ans q4)" ] && [ "$(ans q4)" = "$(cat "$LG_DIR/.lg/q4")" ]; }
same_hash() { [ "$(eval "$1" | git hash-object --stdin)" = "$(cat "$LG_DIR/.lg/$2")" ]; }

expect "q1: the file that is staged AND has unstaged edits"     q1_ok
expect "q2: the new word in README.md"                          q2_ok
expect "q3: the number of files the gift-cards PR changes"      q3_ok
expect "q4: lines added to src/cart.js between v1.0 and v1.1"   q4_ok
expect "main hasn't moved (no commits)"                         same_commit main "$(saved main_tip)"
expect "feature/gift-cards hasn't moved"                        same_commit feature/gift-cards "$(saved gift_tip)"
expect "your staged changes are untouched"                      same_hash "git diff --staged" staged
expect "your unstaged changes are untouched"                    same_hash "git diff" unstaged
finish
