rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
in_repo
expect "repo/ is no longer shallow"                                test "$(git rev-parse --is-shallow-repository)" = false
expect "repo/ has the complete history of main"                    test "$(git rev-list --count "$(saved origin_main)" 2>/dev/null)" = "$(rgit rev-list --count main)"
expect "repo/: main is still the team's main"                      same_commit main "$(saved origin_main)"
expect "ANSWER: the author who added FREE_SHIPPING_THRESHOLD"      answer_is dev@brightcart.example
expect "partial/ exists and is a clone of origin"                  sh -c "[ \"\$(git -C '$LG_DIR/partial' rev-parse -q --verify HEAD)\" = $(saved origin_main) ]"
expect "partial/ is a blobless partial clone (filter blob:none)"   test "$(git -C "$LG_DIR/partial" config --get remote.origin.partialclonefilter)" = blob:none
expect "partial/ is not shallow (it has all commits)"              test "$(git -C "$LG_DIR/partial" rev-parse --is-shallow-repository)" = false
finish
