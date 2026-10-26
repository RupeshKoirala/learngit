in_repo
start=$(saved start)
gone() { for p in "$@"; do [ ! -e "$p" ] || return 1; done; }
end_state() { [ "$(git status --porcelain --untracked-files=all | grep -v ' src/coupon.js$')" = " M src/cart.js" ]; }

expect "main hasn't moved (nothing committed)"              same_commit HEAD "$start"
expect "src/price.js is back to the committed version"      git diff --quiet HEAD -- src/price.js
expect "src/cart.js is no longer staged"                    git diff --cached --quiet -- src/cart.js
expect "your applyCoupon edit is still in src/cart.js"      file_has src/cart.js "function applyCoupon"
expect "src/coupon.js still exists with your code"          file_has src/coupon.js "isValidCoupon"
expect "src/coupon.js is not committed"                     history_lacks_path src/coupon.js
expect "scratch.txt and src/cart.js.orig are deleted"       gone scratch.txt src/cart.js.orig
expect "tmp/ and coverage/ are deleted"                     gone tmp coverage
expect "ignored .env and node_modules/ were kept"           test -f .env -a -f node_modules/left-pad/index.js
expect "git status shows only cart.js modified (+ coupon.js)" end_state
finish
