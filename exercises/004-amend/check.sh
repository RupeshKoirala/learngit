in_repo
expect "you're on main"                                         on_branch main
expect "main has exactly 3 commits"                             count_is HEAD 3
expect "the fixed commit sits on top of 'Add removeItem to cart'"  same_commit HEAD~1 "$(saved base)"
expect "the last commit is titled 'Add free shipping banner'"   msg_is HEAD "Add free shipping banner"
expect "the last commit contains src/banner.js"                 in_commit HEAD src/banner.js
expect "the last commit contains src/banner.css"                in_commit HEAD src/banner.css
expect "src/banner.css is committed exactly as written"         rev_file_has HEAD src/banner.css "font-weight: 600"
expect "the working tree is clean"                              clean_tree
finish
