in_repo
P=$(saved prettier)
blame_threshold() {   # commit that plain `git blame` (with the repo's config) shows for the threshold line
  git blame --porcelain -L '/FREE_SHIPPING_THRESHOLD =/,+1' main -- src/shipping.js 2>/dev/null | head -1 | cut -d' ' -f1
}
expect "you're on main"                                            on_branch main
expect "the original history is untouched (main builds on it)"     is_ancestor "$(saved tip)" main
expect "tag threshold-change marks the commit that set it to 5000" same_commit threshold-change "$(saved threshold)"
expect "ANSWER holds the ticket ID from that commit's message"     answer_is "PRICING-88"
expect "tag express-origin marks who first wrote the express rule" same_commit express-origin "$(saved express)"
expect ".git-blame-ignore-revs is committed on main"               in_commit main .git-blame-ignore-revs
expect "...and lists the full hash of the prettier commit"         rev_file_has main .git-blame-ignore-revs "^$P"
expect "blame.ignoreRevsFile is set to .git-blame-ignore-revs"     test "$(git config blame.ignoreRevsFile)" = ".git-blame-ignore-revs"
expect "plain git blame now shows Dev's change on the threshold"   test "$(blame_threshold)" = "$(saved threshold)"
expect "the working tree is clean"                                 clean_tree
finish
