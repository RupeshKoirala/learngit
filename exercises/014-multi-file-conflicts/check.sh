conflict_style_ok() {
  for _s in "$(git config --get merge.conflictStyle)" \
            "$(git config --file "$HOME/.gitconfig" --get merge.conflictStyle 2>/dev/null)" \
            "$(git config --file "${XDG_CONFIG_HOME:-$HOME/.config}/git/config" --get merge.conflictStyle 2>/dev/null)"; do
    case "$_s" in diff3|zdiff3) return 0 ;; esac
  done
  return 1
}
count_in() { git show "main:$1" 2>/dev/null | grep -cE -- "$2"; }   # count_in <path> <ERE>

in_repo
expect "no merge is in progress"                                     no_operation
expect "you're on main"                                              on_branch main
expect "merge.conflictStyle is diff3 or zdiff3"                      conflict_style_ok
expect "main's tip is a merge commit of release/1.4"                 same_commit main^2 release/1.4
expect "...on top of main as it was (first parent)"                  same_commit main^1 "$(saved main)"
expect "release/1.4 is unchanged (still tagged v1.4.1)"              same_commit release/1.4 v1.4.1
expect "no conflict markers are left"                                eval "no_conflict_markers && ! git grep -qE '^(=======|\|\|\|\|\|\|\|)( |$)'"
expect "cart.js: lineTotal helper is kept"                           rev_file_has main src/cart.js "^function lineTotal\(item\)"
expect "cart.js: exactly one total() function"                       test "$(count_in src/cart.js '^function total\(')" = 1
expect "cart.js: total() rounds AND uses lineTotal"                  rev_file_has main src/cart.js "Math\.round\(.*lineTotal\(i\)"
expect "price.js: currency parameter is kept"                        rev_file_has main src/price.js "function formatPrice\(cents, currency"
expect "price.js: refund branch passes the currency along"           rev_file_has main src/price.js "if \(cents < 0\) return '-' \+ formatPrice\(-cents, currency\)"
expect "price.js: amounts are printed with the currency symbol"      rev_file_has main src/price.js "return currency \+"
expect_not "legacy-coupons.js stays deleted"                         in_commit main src/legacy-coupons.js
expect "discount.js got the expiry fix (expires <= now)"             rev_file_has main src/discount.js "coupon\.expires <= now"
expect "CHANGELOG has the 1.4.1 notes"                               rev_file_has main CHANGELOG.md "^## 1\.4\.1"
expect "the working tree is clean"                                   clean_tree
finish
