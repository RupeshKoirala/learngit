in_repo
expect "main is unchanged"                                         same_commit main "$(saved tip)"
expect "tag removed-applyCoupon marks the commit that removed it"  same_commit removed-applyCoupon "$(saved removed)"
expect "ANSWER names the function that replaced applyCoupon"       answer_is "redeemCode"
expect "tag regex-change marks the commit that broke plus-addresses" same_commit regex-change "$(saved regex)"
finish
