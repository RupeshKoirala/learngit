# block_of <heading-regex>    prints the lines of the v1.5.0 section under a ### heading (case-insensitive)
v15() { awk '/^## /{on = ($0 ~ /^## \[?v?1\.5\.0/)} on' CHANGELOG.md; }
block_of() {
  v15 | awk -v re="$1" '/^### /{ h=tolower($0); on = (h ~ re); next } on'
}
in_block()   { block_of "$1" | grep -qiF -- "$2"; }
nb_bullets() { [ "$(block_of "$1" | grep -cE '^[-*] ')" = "$2" ]; }
v15_lacks()  { ! v15 | grep -qiE -- "$1"; }
ordered()    {
  _a=$(grep -nE '^## \[?v?1\.5\.0' CHANGELOG.md | head -1 | cut -d: -f1)
  _b=$(grep -nE '^## \[?v?1\.4\.0' CHANGELOG.md | head -1 | cut -d: -f1)
  [ -n "$_a" ] && [ -n "$_b" ] && [ "$_a" -lt "$_b" ]
}
no_prefix()  { ! v15 | grep -qE '^[-*] *(feat|fix|chore)(\(|!|:)'; }

in_repo
expect     "you're on main"                                         on_branch main
expect     "CHANGELOG.md has a v1.5.0 section"                      file_has CHANGELOG.md '^## \[?v?1\.5\.0'
expect     "the v1.5.0 section is above v1.4.0"                     ordered
expect     "the v1.4.0 section is still there"                      file_has CHANGELOG.md '^- guest checkout'
expect     "Features lists the 4 features"                          nb_bullets features 4
expect     "Features: save cart between visits"                     in_block features "save cart between visits"
expect     "Features: search API returns paginated results"         in_block features "search API returns paginated results"
expect     "Features: share wishlist by link"                       in_block features "share wishlist by link"
expect     "Features: remove v1 price endpoint"                     in_block features "remove v1 price endpoint"
expect     "Fixes lists the 3 fixes"                                nb_bullets fix 3
expect     "Fixes: round half-cent amounts correctly"               in_block fix "round half-cent amounts correctly"
expect     "Fixes: never double-charge on payment retry"            in_block fix "never double-charge on payment retry"
expect     "Fixes: coupon field accepts lowercase codes"            in_block fix "coupon field accepts lowercase codes"
expect     "Breaking changes lists the 2 breaking commits"          nb_bullets breaking 2
expect     "Breaking: the '!' commit (paginated search)"            in_block breaking "paginated results"
expect     "Breaking: the BREAKING CHANGE footer (v1 price endpoint)" in_block breaking "price"
expect     "bullets don't keep the 'feat(scope): ' prefix"          no_prefix
expect     "no chore commits in v1.5.0 (eslint, lodash)"            v15_lacks 'eslint|lodash'
expect     "no merge commits in v1.5.0"                             v15_lacks 'merge pull request'
expect     "nothing from before v1.4.0 (guest checkout)"            v15_lacks 'guest checkout|badge'
expect_not "nothing from after v1.5.0 (gift cards)"                 file_has CHANGELOG.md 'gift card'
expect     "the changelog is committed on main"                     rev_file_has main CHANGELOG.md '^## \[?v?1\.5\.0'
expect     "the working tree is clean"                              clean_tree
finish
