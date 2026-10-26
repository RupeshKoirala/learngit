ans() {   # ans <key>  -> value of "key=value" in $LG_DIR/ANSWER, spaces removed, lower-case
  [ -f "$LG_DIR/ANSWER" ] || return 0
  sed -n "s/^[[:space:]]*$1[[:space:]]*[=:][[:space:]]*//p" "$LG_DIR/ANSWER" | head -1 | tr -d ' \r\t' | tr 'A-Z' 'a-z'
}
path_is() { _v=$(ans "$1"); _v=${_v#./}; [ "$_v" = "$2" ]; }

in_repo
expect "main is unchanged"                                            same_commit main "$(saved tip)"
expect "tag rounding-change marks the round -> floor commit"          same_commit rounding-change "$(saved rounding)"
expect "q1: number of commits that changed calculateTax"              test "$(ans q1)" = 4
expect "q2: number of files the rounding commit changed"              test "$(ans q2)" = 3
expect "q3: the file that held TAX_RATE_EU in v1.0"                   path_is q3 "src/legacy/vat.js"
finish
