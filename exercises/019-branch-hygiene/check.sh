tracking_ref() { git show-ref --verify -q "refs/remotes/origin/$1"; }

in_repo
expect "you're on main"                                               on_branch main
expect_not "feature/search is deleted locally"                        branch_exists feature/search
expect_not "fix/typo-footer is deleted locally"                       branch_exists fix/typo-footer
expect_not "feature/old-promo-banner is deleted locally"              branch_exists feature/old-promo-banner
expect_not "spike/graphql-experiment is deleted locally"              branch_exists spike/graphql-experiment
expect "main is kept and unchanged"                                   same_commit main "$(saved main)"
expect "release/1.0 is kept and unchanged"                            same_commit release/1.0 "$(saved release)"
expect "feature/checkout-redesign (your WIP) is kept and unchanged"   same_commit feature/checkout-redesign "$(saved wip)"
expect "exactly 3 local branches remain"                              test "$(git for-each-ref refs/heads | grep -c .)" = 3
expect_not "feature/search is deleted on origin"                      remote_has_branch origin feature/search
expect_not "fix/typo-footer is deleted on origin"                     remote_has_branch origin fix/typo-footer
expect "origin still has main, release/1.0 and the checkout WIP"      eval "[ \"\$(remote_ref origin main)\" = \"\$(saved main)\" ] && [ \"\$(remote_ref origin release/1.0)\" = \"\$(saved release)\" ] && [ \"\$(remote_ref origin feature/checkout-redesign)\" = \"\$(saved wip)\" ]"
expect_not "no stale origin/feature/old-promo-banner ref (pruned)"    tracking_ref feature/old-promo-banner
expect_not "no stale origin/feature/search or origin/fix/typo-footer" eval "tracking_ref feature/search || tracking_ref fix/typo-footer"
expect "origin/main and origin/feature/checkout-redesign still exist" eval "tracking_ref main && tracking_ref feature/checkout-redesign"
expect "the working tree is clean"                                    clean_tree
finish
