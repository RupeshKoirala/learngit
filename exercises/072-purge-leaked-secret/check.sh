OLD=pfx_live_9f3c2a7e5b1d4c88a01e
NEW=pfx_live_R0TATED_51b7c2d9e8
O="$LG_DIR/remotes/origin.git"

# key_in <git-dir>: does any commit reachable from any ref contain the old key?
key_in() { _revs=$(git --git-dir="$1" rev-list --all 2>/dev/null); [ -n "$_revs" ] && git --git-dir="$1" grep -q -F "$OLD" $_revs -- 2>/dev/null; }
env_in() { [ -n "$(git --git-dir="$1" log --all --format=%H -- .env 2>/dev/null)" ]; }
remote_same() { [ "$(git --git-dir="$O" rev-parse -q --verify "$1" 2>/dev/null)" = "$(git rev-parse -q --verify "$2" 2>/dev/null)" ]; }
remote_tag_ok() { git --git-dir="$O" rev-parse -q --verify "refs/tags/v0.9^{commit}" >/dev/null && git --git-dir="$O" cat-file -e "refs/tags/v0.9^{commit}:src/payments.js" 2>/dev/null; }
remote_ignores_env() { git --git-dir="$O" show main:.gitignore 2>/dev/null | grep -qE '^/?\.env/?$|^\.env\*?$'; }
enough_commits() { [ "$(git --git-dir="$O" rev-list --count main 2>/dev/null || echo 0)" -ge "$(cat "$LG_DIR/.lg/main.count")" ]; }

in_repo
expect "no rebase/merge is in progress"                          no_operation
expect "you're on main"                                          on_branch main
expect_not "origin: no branch or tag has .env anywhere in its history"   env_in "$O"
expect_not "origin: the old key is in no commit reachable from any ref"  key_in "$O"
expect_not "local: no branch or tag has .env in its history"     env_in "$(git rev-parse --git-dir)"
expect_not "local: the old key is gone from every reachable commit" key_in "$(git rev-parse --git-dir)"
expect "the origin remote is configured again"                   test "$(git remote get-url origin 2>/dev/null)" != ""
expect "origin/main and your main are the same commit"           remote_same refs/heads/main main
expect "origin still has feature/refunds (rewritten, with refunds.js)" git --git-dir="$O" cat-file -e "refs/heads/feature/refunds:src/refunds.js"
expect "origin still has the v0.9 tag (rewritten)"               remote_tag_ok
expect "no commits were lost on main"                            enough_commits
expect "'Add PayFlux payment client' is still in main's history" history_has_msg '^Add PayFlux payment client$' main
expect "src/payments.js is still in main"                        in_commit main src/payments.js
expect ".gitignore on origin/main ignores .env"                  remote_ignores_env
expect ".env exists on disk with the NEW key"                    file_has .env "^PAYFLUX_SECRET=$NEW\$"
expect ".env is ignored by Git"                                  git check-ignore -q .env
expect_not ".env is not tracked"                                 tracked .env
expect "the working tree is clean"                               clean_tree
finish
