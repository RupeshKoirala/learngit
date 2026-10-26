only_readme_changed() { [ "$(git status --porcelain --untracked-files=all | awk '{print $NF}')" = "README.md" ]; }

in_repo
expect "no merge is in progress"                                    no_operation
expect "you're on main"                                              on_branch main
expect "main is back at origin/main's commit (search merge undone)"  same_commit main "$(saved main)"
expect "src/search.js is gone from the working tree"                 test ! -e src/search.js
expect "no conflict markers left in any file"                        no_conflict_markers
expect "src/cart.js and src/price.js match main again"               git diff --quiet HEAD -- src
expect "your README note is still there"                             file_has README.md "^Search: type in the box"
expect "…and still not committed"                                    test -z "$(git log --format=%H -1 -G 'Search: type in the box' main)"
expect "README.md is the only changed file"                          only_readme_changed
expect "feature/search is untouched"                                 same_commit feature/search "$(saved search)"
expect "feature/sort-by-price is untouched"                          same_commit feature/sort-by-price "$(saved sort)"
expect "nothing was pushed: origin/main is unchanged"                test "$(remote_ref origin main)" = "$(saved main)"
finish
