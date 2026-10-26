rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
rtag_type() { rgit cat-file -t "refs/tags/$1" 2>/dev/null; }
rtag_peel() { rgit rev-parse -q --verify "refs/tags/$1^{commit}" 2>/dev/null; }
in_repo
expect "v2.4.0 is on origin"                                    test -n "$(rtag_peel v2.4.0)"
expect "origin's v2.4.0 is an annotated tag"                    test "$(rtag_type v2.4.0)" = tag
expect "origin's v2.4.0 points at 'Release 2.4.0'"              test "$(rtag_peel v2.4.0)" = "$(saved release_240)"
expect "tmp-before-refactor was NOT pushed"                     test -z "$(rtag_peel tmp-before-refactor)"
expect "bisect-good was NOT pushed"                             test -z "$(rtag_peel bisect-good)"
expect "origin's v2.3.1 points at 'Bump version to 2.3.1'"      test "$(rtag_peel v2.3.1)" = "$(saved right_231)"
expect "origin's v2.3.1 is an annotated tag"                    test "$(rtag_type v2.3.1)" = tag
expect "your local v2.3.1 matches (annotated, right commit)"    sh -c "[ \"\$(git cat-file -t refs/tags/v2.3.1)\" = tag ] && [ \"\$(git rev-parse v2.3.1^{commit})\" = $(saved right_231) ]"
expect "origin's v2.3.0 is untouched"                           test "$(rgit rev-parse -q --verify refs/tags/v2.3.0)" = "$(cat "$LG_DIR/.lg/tag230.obj")"
expect "Dev's clone has the corrected v2.3.1"                   test "$(git -C "$LG_DIR/.team/dev" rev-parse -q --verify 'v2.3.1^{commit}')" = "$(saved right_231)"
expect "origin's main was not changed"                          test "$(remote_ref origin main)" = "$(saved release_240)"
finish
