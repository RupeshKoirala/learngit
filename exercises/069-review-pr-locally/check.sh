rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
in_repo
expect "local branch pr-42 holds PR #42's commits"                    same_commit pr-42 "$(saved pr42)"
expect "origin is configured to fetch refs/pull/*/head"               sh -c "git config --get-all remote.origin.fetch | grep -q 'refs/pull/\*/head'"
expect "the normal branch refspec is still there"                     sh -c "git config --get-all remote.origin.fetch | grep -qF '+refs/heads/*:refs/remotes/origin/*'"
expect "origin/pr/42 and origin/pr/43 were fetched"                   sh -c "[ \"\$(git rev-parse -q --verify refs/remotes/origin/pr/42)\" = $(saved pr42) ] && [ \"\$(git rev-parse -q --verify refs/remotes/origin/pr/43)\" = $(saved pr43) ]"
expect "ANSWER line 1 is your verdict: request changes"               sh -c "head -n 1 '$LG_DIR/ANSWER' | grep -qiE '^ *request[ _-]?changes'"
expect "ANSWER names the file with the problem (src/shipping.js)"     grep -qi 'shipping\.js' "$LG_DIR/ANSWER"
expect "ANSWER explains the threshold problem (>=, inclusive, 'or more' …)" grep -qiE '>=|inclusive|or more|exactly|5000|50(\.00)?|threshold|boundary|off.by.one' "$LG_DIR/ANSWER"
expect "PR #42 on origin is unchanged (you didn't push to it)"        test "$(rgit rev-parse -q --verify refs/pull/42/head)" = "$(saved pr42)"
expect "nothing new was pushed to origin (only main exists)"          test "$(rgit for-each-ref --format=x refs/heads | wc -l | tr -d ' ')" = 1
expect "main is unchanged"                                            sh -c "[ \"\$(git rev-parse main)\" = $(saved main_tip) ] && [ \"\$(git --git-dir='$LG_DIR/remotes/origin.git' rev-parse main)\" = $(saved main_tip) ]"
finish
