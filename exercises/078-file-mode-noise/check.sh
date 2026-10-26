O=$(saved original)
modes_ok() { git ls-tree -r HEAD | awk '{ want = ($4 == "test.sh") ? "100755" : "100644"; if ($1 != want) bad = 1 } END { exit bad }'; }
blobs_same() { [ "$(git ls-tree -r HEAD | awk '{print $3, $4}')" = "$(git ls-tree -r "$O" | awk '{print $3, $4}')" ]; }

in_repo
expect "no operation is in progress"                            no_operation
expect "you're on main"                                         on_branch main
expect "Lena's commit is still in history (no rewrite)"         is_ancestor "$O" main
expect "you added a commit on top"                              test "$(git rev-parse HEAD)" != "$O"
expect "test.sh is 100755 in Git"                               test "$(git ls-tree HEAD test.sh | cut -d' ' -f1)" = 100755
expect "every other file is 100644 in Git"                      modes_ok
expect "file contents are unchanged (incl. Lena's cart.js edit)" blobs_same
expect "core.fileMode is still true in this repo"               test "$(git config --local --bool core.fileMode)" = true
expect "the working tree is clean (disk modes match Git)"       clean_tree
expect "test.sh is executable on disk"                          test -x test.sh
finish
