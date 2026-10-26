ans() {   # ans <key>  -> value of "key=value" in $LG_DIR/ANSWER, spaces removed, lower-case
  [ -f "$LG_DIR/ANSWER" ] || return 0
  sed -n "s/^[[:space:]]*$1[[:space:]]*[=:][[:space:]]*//p" "$LG_DIR/ANSWER" | head -1 | tr -d ' \r\t' | tr 'A-Z' 'a-z'
}
ans_commit_is() {   # ans_commit_is <key> <commit>   value is a (short) hash resolving to <commit>
  _v=$(ans "$1"); [ -n "$_v" ] || return 1
  [ "$(git rev-parse -q --verify "$_v^{commit}" 2>/dev/null)" = "$2" ]
}

in_repo
expect "you fetched: origin/feature/wishlist is Lena's v2"                same_commit origin/feature/wishlist "$(saved v2)"
expect "tag changed-commit marks the v2 commit whose code changed"        same_commit changed-commit "$(saved capv2)"
expect "ANSWER cap= holds the new MAX_ITEMS value"                        test "$(ans cap)" = 20
expect "ANSWER dropped= holds the v1 hash of the dropped commit"          ans_commit_is dropped "$(saved debug)"
expect "no local branches besides main"                                   test "$(git for-each-ref --format='%(refname)' refs/heads)" = "refs/heads/main"
finish
