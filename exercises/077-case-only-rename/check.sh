O=$(saved original)
idx_only() { [ "$(git ls-files | grep -ixF "$1")" = "$1" ]; }          # exactly one entry, with this exact case
disk_name() { ( cd "$(dirname "$1")" && ls -a | grep -qxF "$(basename "$1")" ); }
pure_rename() { git diff -M --name-status "$O" HEAD | grep -qxF "R100	$1	$2"; }
same_blob() { [ "$(git rev-parse "HEAD:$2" 2>/dev/null)" = "$(git rev-parse "$O:$1")" ]; }

in_repo
expect "no operation is in progress"                         no_operation
expect "you're on main"                                      on_branch main
expect "existing history is untouched"                       is_ancestor "$O" main
expect "the index has README.md and no other-case variant"   idx_only README.md
expect "the index has src/utils.js and no other-case variant" idx_only src/utils.js
expect "on disk the files are named README.md and src/utils.js" eval 'disk_name README.md && disk_name src/utils.js'
expect "README.md and src/utils.js have the same content as before" eval 'same_blob readme.md README.md && same_blob src/Utils.js src/utils.js'
expect "Git sees readme.md -> README.md as a 100% rename"    pure_rename readme.md README.md
expect "Git sees src/Utils.js -> src/utils.js as a 100% rename" pure_rename src/Utils.js src/utils.js
expect "src/cart.js requires './utils'"                      rev_file_has HEAD src/cart.js "require\('\./utils'\)"
expect_not "no require('./Utils') is left anywhere"          git grep -q "require('./Utils')" HEAD
expect "the working tree is clean"                           clean_tree
finish
