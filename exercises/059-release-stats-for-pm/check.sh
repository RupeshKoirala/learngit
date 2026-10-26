ans() {   # ans <key>  -> value of "key=value" in $LG_DIR/ANSWER, spaces removed, lower-case
  [ -f "$LG_DIR/ANSWER" ] || return 0
  sed -n "s/^[[:space:]]*$1[[:space:]]*[=:][[:space:]]*//p" "$LG_DIR/ANSWER" | head -1 | tr -d ' \r\t' | tr 'A-Z' 'a-z'
}
want() { tr -d ' \r\t\n' < "$LG_DIR/.lg/$1" | tr 'A-Z' 'a-z'; }
top_ok() {   # accepts "Dev Patel", "Dev Patel <dev@...>" or just the canonical email
  _a=$(ans top); _w=$(want top)
  case "$_a" in "$_w"|"$_w<"*|"dev@brightcart.example") return 0 ;; esac; return 1
}
mailmap_ok() { [ "$(git check-mailmap 'Dev P. <dev.patel@home.example>' 2>/dev/null)" = "Dev Patel <dev@brightcart.example>" ]; }

in_repo
expect "you're on main"                                                on_branch main
expect "the original history is untouched"                            is_ancestor "$(saved tip)" main
expect ".mailmap is committed on main"                                 in_commit main .mailmap
expect ".mailmap maps Dev P. <dev.patel@home.example> to Dev Patel"    mailmap_ok
expect "shortlog for v2.0..v2.1 now shows 4 people"                    test "$(git shortlog -sne v2.0..v2.1 | wc -l | tr -d ' ')" = 4
expect "top= names the real top contributor"                           top_ok
expect "commits= is the number of commits in v2.0..v2.1"               test "$(ans commits)" = "$(want commits)"
expect "since= counts v2.0..v2.1 commits from 2025-03-01 on"           test "$(ans since)" = "$(want since)"
expect "hotfile= is the file changed in the most commits"              test "$(ans hotfile | sed 's|^\./||')" = "$(want hotfile)"
expect "the working tree is clean"                                     clean_tree
finish
