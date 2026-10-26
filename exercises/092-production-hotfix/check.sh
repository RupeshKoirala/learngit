annotated()  { [ "$(git cat-file -t "refs/tags/$1" 2>/dev/null)" = tag ]; }
remote_tag_is() { [ "$(git --git-dir="$LG_DIR/remotes/origin.git" rev-parse -q --verify "refs/tags/$1^{commit}" 2>/dev/null)" = "$(git rev-parse "$1^{commit}" 2>/dev/null)" ]; }
remote_is()  { [ "$(remote_ref origin "$1")" = "$(git rev-parse "$1" 2>/dev/null)" ]; }
has_fix()    { rev_file_has "$1" src/shipping.js 'totalCents >= FREE_SHIPPING_FROM'; }
minimal()    { _o=$(git diff --name-only v2.0.0 v2.0.1 2>/dev/null) && [ -n "$_o" ] && \
               [ -z "$(printf '%s\n' "$_o" | grep -vE '^(src/shipping\.js|VERSION|CHANGELOG\.md)$')" ]; }

in_repo
expect     "no merge, rebase or cherry-pick is in progress"          no_operation
expect     "the tag v2.0.0 was not moved"                            same_commit v2.0.0 "$(saved v200)"
expect     "branch hotfix/2.0.1 exists"                              branch_exists hotfix/2.0.1
expect     "hotfix/2.0.1 is based on v2.0.0"                         is_ancestor v2.0.0 hotfix/2.0.1
expect     "v2.0.1 exists and is an annotated tag"                   annotated v2.0.1
expect     "v2.0.1 is on the hotfix branch"                          is_ancestor v2.0.1 hotfix/2.0.1
expect     "v2.0.1 builds on v2.0.0"                                 is_ancestor v2.0.0 v2.0.1
expect     "v2.0.1 has the shipping fix"                             has_fix v2.0.1
expect     "v2.0.1 says VERSION 2.0.1"                               rev_file_has v2.0.1 VERSION '^2\.0\.1$'
expect_not "v2.0.1 doesn't ship loyalty points"                      is_ancestor "$(saved loyalty)" v2.0.1
expect_not "v2.0.1 doesn't ship the new carriers"                    rev_file_has v2.0.1 src/shipping.js DHL
expect     "v2.0.0..v2.0.1 only touches shipping.js/VERSION/CHANGELOG" minimal
expect     "main has the fix"                                        has_fix main
expect     "main kept its unreleased work"                           is_ancestor "$(saved devtip)" main
expect     "main's VERSION is still 2.1.0-dev"                       rev_file_has main VERSION '^2\.1\.0-dev$'
expect     "main still has the new carriers"                         rev_file_has main src/shipping.js "'DHL', 'UPS'"
expect     "origin/main is pushed"                                   remote_is main
expect     "origin/hotfix/2.0.1 is pushed"                           remote_is hotfix/2.0.1
expect     "the tag v2.0.1 is on origin"                             remote_tag_is v2.0.1
expect     "the working tree is clean"                               clean_tree
finish
