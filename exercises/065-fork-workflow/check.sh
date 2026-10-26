F=feature/size-guide
upgit()   { git --git-dir="$LG_DIR/remotes/brightcart.git" "$@"; }
forkgit() { git --git-dir="$LG_DIR/remotes/fork.git" "$@"; }
in_repo
expect "no rebase or merge is in progress"                         no_operation
expect "remote 'upstream' points at the company repo"              sh -c 'git remote get-url upstream | grep -q "remotes/brightcart\.git$"'
expect "remote 'origin' still points at your fork"                 sh -c 'git remote get-url origin | grep -q "remotes/fork\.git$"'
expect "you fetched upstream (upstream/main is current)"           same_commit upstream/main "$(saved upstream_main)"
expect "your local main equals upstream's main"                    same_commit main "$(saved upstream_main)"
expect "your fork's main equals upstream's main"                   test "$(forkgit rev-parse -q --verify main)" = "$(saved upstream_main)"
expect "$F is rebased onto the latest upstream main"               is_ancestor "$(saved upstream_main)" $F
expect "$F still has exactly 2 commits on top, no merges"          sh -c "[ \"\$(git rev-list --count $(saved upstream_main)..$F)\" = 2 ] && [ \"\$(git rev-list --merges --count $(saved upstream_main)..$F)\" = 0 ]"
expect "your fork's $F matches your local branch"                  test "$(forkgit rev-parse -q --verify $F)" = "$(git rev-parse $F)"
expect "nothing was pushed to the company repo"                    sh -c "[ \"\$(git --git-dir='$LG_DIR/remotes/brightcart.git' for-each-ref --format=x refs/heads | wc -l | tr -d ' ')\" = 1 ] && [ \"\$(git --git-dir='$LG_DIR/remotes/brightcart.git' rev-parse main)\" = $(saved upstream_main) ]"
expect "the working tree is clean"                                 clean_tree
finish
