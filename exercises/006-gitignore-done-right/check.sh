in_repo
start=$(saved start)
ignored()     { git check-ignore -q --no-index "$1"; }
not_ignored() { ! git check-ignore -q --no-index "$1"; }
not_in_head() { ! in_commit HEAD "$1"; }
answer_has()  { [ -f "$LG_DIR/ANSWER" ] && grep -qF -- "$1" "$LG_DIR/ANSWER"; }

expect "you're on main, building on the existing history"      is_ancestor "$start" HEAD
expect "node_modules/ is ignored"                               ignored node_modules/left-pad/index.js
expect ".env, .env.local and .env.production are ignored"       eval 'ignored .env && ignored .env.local && ignored .env.production'
expect ".env.example is NOT ignored"                            not_ignored .env.example
expect "files inside logs/ are ignored (e.g. logs/today.txt)"   ignored logs/today.txt
expect "logs/.gitkeep is NOT ignored (rule works for new clones too)"  not_ignored logs/.gitkeep
expect "*.log files are ignored anywhere (e.g. src/debug.log)"  ignored src/debug.log
expect "node_modules/ is no longer tracked"                     not_in_head node_modules
expect ".env and .env.local are no longer tracked"              eval '! in_commit HEAD .env && ! in_commit HEAD .env.local'
expect "logs/app.log is no longer tracked"                      not_in_head logs/app.log
expect ".env.example and logs/.gitkeep are still tracked"       eval 'in_commit HEAD .env.example && in_commit HEAD logs/.gitkeep'
expect "the files are still on disk"                            test -f .env -a -f .env.local -a -f logs/app.log -a -f node_modules/left-pad/index.js
expect "ANSWER names the file that ignored the logo"            answer_has "assets/.gitignore"
expect "assets/logo.png is committed"                           in_commit HEAD assets/logo.png
expect "other PNG exports are still ignored (assets/hero.png)"  ignored assets/hero.png
expect "the working tree is clean"                              clean_tree
finish
