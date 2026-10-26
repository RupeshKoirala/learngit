annotated()  { [ "$(git cat-file -t "refs/tags/$1" 2>/dev/null)" = tag ]; }
remote_tag() { git --git-dir="$LG_DIR/remotes/origin.git" rev-parse -q --verify "refs/tags/$1^{commit}" >/dev/null; }
remote_is()  { [ "$(remote_ref origin "$1")" = "$(git rev-parse "$1" 2>/dev/null)" ]; }
fixed()      { rev_file_has "$1" src/checkout.js 'TAX_RATE = 0\.08;' && rev_file_has "$1" src/price.js 'toFixed\(2\)'; }
fix_commits(){ [ "$(git rev-list --no-merges --count "$(saved freeze)..release/2.0" 2>/dev/null)" -ge 2 ]; }
separate()   {   # some commit on the release branch touches checkout.js but not price.js, and vice versa
  _a=0; _b=0
  for c in $(git rev-list --no-merges "$(saved freeze)..release/2.0"); do
    _f=$(git diff-tree --no-commit-id --name-only -r "$c")
    case "$_f" in *src/checkout.js*) case "$_f" in *src/price.js*) ;; *) _a=1;; esac;; esac
    case "$_f" in *src/price.js*) case "$_f" in *src/checkout.js*) ;; *) _b=1;; esac;; esac
  done
  [ "$_a" = 1 ] && [ "$_b" = 1 ]
}

in_repo
expect     "no merge, rebase or cherry-pick is in progress"            no_operation
expect     "branch release/2.0 exists"                                 branch_exists release/2.0
expect     "release/2.0 starts from the code-freeze commit"            is_ancestor "$(saved freeze)" release/2.0
expect_not "release/2.0 does not contain gift wrapping (that's 2.1)"   is_ancestor "$(saved giftwrap)" release/2.0
expect     "release/2.0 has the BC-201 and BC-202 fixes"               fixed release/2.0
expect     "the two fixes are two separate commits"                    separate
expect     "v2.0.0 exists and is an annotated tag"                     annotated v2.0.0
expect     "v2.0.0 points at a commit on release/2.0"                  is_ancestor v2.0.0 release/2.0
expect     "v2.0.0 contains both fixes"                                fixed v2.0.0
expect     "v2.0.0 says VERSION 2.0.0"                                 rev_file_has v2.0.0 VERSION '^2\.0\.0$'
expect_not "v2.0.0 doesn't ship gift wrapping"                         is_ancestor "$(saved giftwrap)" v2.0.0
expect     "release/2.0 is merged back into main"                      is_ancestor release/2.0 main
expect     "main has both fixes"                                       fixed main
expect     "main still has gift wrapping"                              in_commit main src/giftwrap.js
expect     "main's VERSION is still 2.1.0-dev"                         rev_file_has main VERSION '^2\.1\.0-dev$'
expect     "origin/main is pushed"                                     remote_is main
expect     "origin/release/2.0 is pushed"                              remote_is release/2.0
expect     "the tag v2.0.0 is on origin"                               remote_tag v2.0.0
expect     "the working tree is clean"                                 clean_tree
finish
