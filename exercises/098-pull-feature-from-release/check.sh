REL=$(saved release)
lists_all() {   # every gift-card commit is named by a 7+ char hash in the revert commit's message
  _m=$(git log -1 --format=%B release/2.3)
  for _n in 1 2 3 4 5 6; do
    _g=$(saved "gift$_n"); _ok=1
    for _h in $(printf '%s\n' "$_m" | grep -oE '[0-9a-f]{7,40}'); do case "$_g" in "$_h"*) _ok=0;; esac; done
    [ "$_ok" = 0 ] || return 1
  done
}
no_gift() { ! git grep -qiE 'giftcard|gift card' release/2.3 -- . ; }

in_repo
expect     "no revert, merge or cherry-pick is in progress"              no_operation
expect     "release/2.3 was not rewritten"                               is_ancestor "$REL" release/2.3
expect     "exactly one new commit on release/2.3"                       count_is "$REL..release/2.3" 1
expect_not "the new commit is not a merge"                               is_merge release/2.3
expect     "release/2.3 has no gift-card code left"                      no_gift
expect_not "src/giftcards.sh is gone from the release"                   in_commit release/2.3 src/giftcards.sh
expect     "saved payment cards still ship"                              in_commit release/2.3 src/saved_cards.sh
expect     "search + release fix still ship"                             rev_file_has release/2.3 src/search.sh 'return 0; grep -i .* \| sort -u \| head -50'
expect     "tax rounding fix still ships"                                rev_file_has release/2.3 src/checkout.sh '\(total \* 8 \+ 50\) / 100'
expect     "README change and VERSION 2.3.0-rc1 still ship"              sh -c 'git show release/2.3:README.md | grep -q help@ && git show release/2.3:VERSION | grep -qx 2.3.0-rc1'
expect     "release/2.3 is exactly 'everything minus the six gift-card commits'" tree_is_saved release/2.3 expected
expect     "the commit subject says it reverts gift cards"               sh -c 'git log -1 --format=%s release/2.3 | grep -qi revert && git log -1 --format=%s release/2.3 | grep -qi gift'
expect     "the commit message lists all six reverted hashes"            lists_all
expect     "main was not touched (gift cards stay for 2.4)"              same_commit main "$(saved main)"
expect     "the working tree is clean"                                   clean_tree
finish
