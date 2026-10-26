ans() {   # ans <key>  -> value of "key=value" (or "key: value") in $LG_DIR/ANSWER, spaces removed, lower-case
  [ -f "$LG_DIR/ANSWER" ] || return 0
  sed -n "s/^[[:space:]]*$1[[:space:]]*[=:][[:space:]]*//p" "$LG_DIR/ANSWER" | head -1 | tr -d ' \r\t' | tr 'A-Z' 'a-z'
}
ans_is() { [ "$(ans "$1")" = "$2" ]; }

in_repo
expect "main, origin/main and feature/gift-cards haven't moved" \
  test "$(git rev-parse main origin/main feature/gift-cards)" = "$(printf '%s\n%s\n%s' "$(saved main)" "$(saved originmain)" "$(saved feature)")"
expect "q1: commits a pull would bring in (main..origin/main)"           ans_is q1 3
expect "q2: your unpushed commits (origin/main..main)"                   ans_is q2 2
expect "q3: symmetric difference (main...origin/main)"                   ans_is q3 5
expect "q4: first-parent commits on feature/gift-cards"                  ans_is q4 4
expect "q5: release/1.3 commits on neither main nor origin/main"         ans_is q5 3
expect "tag needs-port marks the hotfix that still needs porting"        same_commit needs-port "$(saved crashfix)"
finish
