B=feature/sale-prices
in_repo
expect "no merge is in progress"                                  no_operation
expect "you're on feature/sale-prices"                            on_branch "$B"
expect "main hasn't moved"                                        same_commit main "$(saved main)"
expect "main is merged into feature/sale-prices"                  is_ancestor main "$B"
expect "'Add formatSalePrice' and 'Add sale banner' are in the history" eval 'history_has_msg "^Add formatSalePrice$" $B && history_has_msg "^Add sale banner$" $B'
expect "src/price.js no longer exists"                            eval '! in_commit $B src/price.js'
expect "src/utils/money.js has your formatSalePrice"              rev_file_has "$B" src/utils/money.js "^function formatSalePrice\(cents, percentOff\) \{"
expect "src/utils/money.js exports formatSalePrice"               rev_file_has "$B" src/utils/money.js "^exports\.formatSalePrice = formatSalePrice;"
expect "src/utils/money.js still has Lena's parseMoney and toCents" eval 'rev_file_has $B src/utils/money.js "^function parseMoney" && rev_file_has $B src/utils/money.js "^function toCents"'
expect "src/utils/money.js still has formatPrice and formatRange" eval 'rev_file_has $B src/utils/money.js "^function formatPrice" && rev_file_has $B src/utils/money.js "^function formatRange"'
expect "src/sale-banner.js requires './utils/money'"              rev_file_has "$B" src/sale-banner.js "require\('\./utils/money'\)"
expect_not "nothing requires './price' anymore"                   git grep -q "require('./price')" "$B"
expect "no conflict markers"                                      no_conflict_markers
expect "the working tree is clean"                                clean_tree
finish
