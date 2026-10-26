url_ends() { git remote get-url "$1" 2>/dev/null | grep -q "remotes/$2\$"; }
has_refs() { [ -n "$(git for-each-ref --format=x "refs/remotes/$1/")" ]; }
in_repo
expect "remote 'backup' points at remotes/backup.git"           url_ends backup backup.git
expect "your local main still has 'Add returns policy page'"    same_commit main "$(saved mine)"
expect "origin's main has your new commit"                      test "$(remote_ref origin main)" = "$(saved mine)"
expect "backup's main has your new commit"                      test "$(remote_ref backup main)" = "$(saved mine)"
expect "origin still fetches from remotes/origin.git"           url_ends origin origin.git
expect "there's no remote named 'gitlab' any more"              sh -c '! git remote | grep -qx gitlab'
expect "no gitlab/* remote-tracking refs left"                  sh -c "[ -z \"\$(git for-each-ref --format=x refs/remotes/gitlab/)\" ]"
expect "remote 'legacy' points at remotes/legacy.git"           url_ends legacy legacy.git
expect "legacy/main was fetched"                                test "$(git rev-parse -q --verify refs/remotes/legacy/main)" = "$(cat "$LG_DIR/.lg/legacy_main")"
expect "the heroku remote is removed"                           sh -c '! git remote | grep -qx heroku'
expect "no heroku/* remote-tracking refs left"                  sh -c "[ -z \"\$(git for-each-ref --format=x refs/remotes/heroku/)\" ]"
expect "the working tree is clean"                              clean_tree
finish
