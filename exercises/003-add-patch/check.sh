in_repo
start=$(saved start)
commit_titled() { git log --format='%H %s' "$start..HEAD" 2>/dev/null | while read -r h s; do [ "$s" = "$1" ] && echo "$h" && break; done; }
added_in()   { git show --format= "$1" | grep '^+' | grep -v '^+++'; }      # lines a commit adds
c_adds()     { _c=$(commit_titled "$1"); [ -n "$_c" ] && added_in "$_c" | grep -qF -- "$2"; }
c_lacks()    { _c=$(commit_titled "$1"); [ -n "$_c" ] && ! added_in "$_c" | grep -qF -- "$2"; }
c_only_cart(){ _c=$(commit_titled "$1"); [ -n "$_c" ] && [ "$(git diff-tree --no-commit-id --name-only -r "$_c")" = "src/cart.js" ]; }
only_debug_left() {   # the only remaining change: exactly one added console.log line, unstaged
  [ "$(git diff --numstat)" = "1	0	src/cart.js" ] && git diff | grep -q "^+.*console.log('DEBUG addItem'"
}
F="Fix total for items without qty"; A="Add clearCart helper"

expect "you're on main"                                     on_branch main
expect "there are exactly 2 new commits"                    count_is "$start..HEAD" 2
expect "'$F' exists and only touches src/cart.js"           c_only_cart "$F"
expect "'$F' contains the (i.qty || 1) fix"                 c_adds "$F" "(i.qty || 1)"
expect "'$F' does not contain clearCart"                    c_lacks "$F" "clearCart"
expect "'$A' exists and only touches src/cart.js"           c_only_cart "$A"
expect "'$A' contains the clearCart function"               c_adds "$A" "function clearCart"
expect "'$A' does not contain the qty fix"                  c_lacks "$A" "(i.qty || 1)"
expect "no commit contains the console.log debug line"      test -z "$(git log -S"console.log('DEBUG" --format=%h "$start..HEAD")"
expect "the commits add up to fix + feature exactly"        tree_is_saved HEAD target
expect "nothing is staged"                                  nothing_staged
expect "the debug line is still in your working tree (and nothing else)"  only_debug_left
finish
