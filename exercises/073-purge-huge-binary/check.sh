O="$LG_DIR/remotes/origin.git"
# biggest reachable blob (bytes) in a git dir
biggest() { git --git-dir="$1" rev-list --objects --all | git --git-dir="$1" cat-file --batch-check='%(objecttype) %(objectsize)' | awk '$1=="blob" && $2>m {m=$2} END {print m+0}'; }
small_remote() { [ "$(biggest "$O")" -lt 1000000 ]; }
small_local()  { git count-objects -v | awk '/^size: /{s+=$2} /^size-pack: /{s+=$2} END {exit !(s < 2048)}'; }
remote_has_path() { [ -n "$(git --git-dir="$O" log --all --format=%H -- "$1" 2>/dev/null)" ]; }
same_files() { [ "$(git ls-tree -r main | grep -v '	\.gitignore$')" = "$(cat "$LG_DIR/.lg/main.files")" ]; }
remote_same() { [ "$(git --git-dir="$O" rev-parse -q --verify "refs/heads/$1")" = "$(git rev-parse -q --verify "$1")" ]; }
ignores_mov() { git show main:.gitignore 2>/dev/null | grep -qE '^(\*\*/|assets/)?\*\.mov$'; }

in_repo
expect "no rebase/merge is in progress"                         no_operation
expect "you're on main"                                         on_branch main
expect "local: promo-video.mov is in no commit on any branch"   history_lacks_path assets/promo-video.mov
expect "local: .git is under 2 MiB (count-objects size + size-pack)" small_local
expect_not "origin: promo-video.mov is in no commit on any branch"  remote_has_path assets/promo-video.mov
expect "origin: no blob over 1 MB is reachable from any ref"   small_remote
expect "'Add homepage hero' is still in main's history"        history_has_msg '^Add homepage hero$' main
expect "assets/hero.png and src/home.js still exist on main"   test -n "$(git ls-tree main assets/hero.png)" -a -n "$(git ls-tree main src/home.js)"
expect "every other file on main is exactly as before"         same_files
expect ".gitignore on main ignores *.mov"                       ignores_mov
expect "origin main == your main"                               remote_same main
expect "origin feature/gift-cards == your feature/gift-cards"   remote_same feature/gift-cards
expect "feature/gift-cards still has 'Start gift cards'"        history_has_msg '^Start gift cards$' feature/gift-cards
expect "the working tree is clean"                              clean_tree
finish
