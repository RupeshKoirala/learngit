in_repo
expect "feature/wishlist is on origin with both your commits"                  test "$(remote_ref origin feature/wishlist)" = "$(git rev-parse -q --verify feature/wishlist)"
expect "feature/wishlist tracks origin/feature/wishlist"                       test "$(upstream_of feature/wishlist)" = origin/feature/wishlist
expect "hotfix/tax-rounding tracks origin/hotfix/tax-rounding"                 test "$(upstream_of hotfix/tax-rounding)" = origin/hotfix/tax-rounding
expect "ANSWER: hotfix/tax-rounding was 2 commits behind"                      answer_is 2
expect "hotfix/tax-rounding is up to date with Lena's latest commit"           same_commit hotfix/tax-rounding "$(saved hotfix_tip)"
expect "experiment/search-ranking has no upstream any more"                    test -z "$(upstream_of experiment/search-ranking)"
expect "experiment/search-ranking was not pushed"                              test -z "$(remote_ref origin experiment/search-ranking)"
expect "push.autoSetupRemote is true in this repo's config"                    test "$(git config --local --get push.autoSetupRemote)" = true
expect "chore/update-deps is on origin"                                        test "$(remote_ref origin chore/update-deps)" = "$(git rev-parse -q --verify chore/update-deps)"
expect "chore/update-deps tracks origin/chore/update-deps"                     test "$(upstream_of chore/update-deps)" = origin/chore/update-deps
expect "origin's main was not touched"                                         test "$(remote_ref origin main)" = "$(git rev-parse origin/main)"
finish
