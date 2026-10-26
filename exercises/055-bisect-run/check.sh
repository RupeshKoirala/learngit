in_repo
expect "tag first-bad marks the commit that really broke cents formatting" same_commit first-bad "$(saved firstbad)"
expect "first-bad is not one of the untestable WIP commits"                 test -n "$(git ls-tree first-bad bin/price 2>/dev/null)"
expect "no bisect session is left in progress (git bisect reset)"           no_operation
expect "no leftover refs/bisect/* refs"                                     test -z "$(git for-each-ref refs/bisect)"
expect "you're back on main"                                                on_branch main
expect "main is unchanged"                                                  same_commit main "$(saved tip)"
finish
