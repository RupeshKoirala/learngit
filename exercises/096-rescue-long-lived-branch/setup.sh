new_bare "$LG_DIR/remotes/origin.git"
new_repo repo
git remote add origin ../remotes/origin.git

write README.md "# Brightcart storefront" "" "Shell-powered demo shop. Run ./test.sh"
cat > test.sh <<'X'
#!/bin/sh
# Runs every tests/test_*.sh from the repo root
fail=0
for t in tests/test_*.sh; do
  if sh "$t"; then echo "ok   $t"; else echo "FAIL $t"; fail=1; fi
done
exit $fail
X
chmod +x test.sh
mkdir -p src
cat > src/money.sh <<'X'
# Money helpers

# format_price <cents>
format_price() {
  printf '$%d.%02d\n' $(($1 / 100)) $(($1 % 100))
}
X
write src/cart.sh "# Cart helpers" "item_count() { echo \"\$#\"; }"
mkdir -p tests
cat > tests/test_money.sh <<'X'
. ./src/money.sh
[ "$(format_price 1999)" = '$19.99' ] || { echo "  format_price 1999 gave $(format_price 1999)"; exit 1; }
X
as maya; commit "chore: storefront skeleton with tests"
git push -q -u origin main

# ---- three months ago: Dev starts multi-currency ----
day 2
git switch -q -c feature/multi-currency
as dev
cat > src/currency.sh <<'X'
# Currency conversion

# convert <usd_cents> <currency>
convert() {
  case "$2" in
    USD) echo "$1" ;;
    EUR) echo $(($1 * 92 / 100)) ;;
    GBP) echo $(($1 * 79 / 100)) ;;
    *) return 1 ;;
  esac
}
X
commit "feat(currency): exchange rate table"
cat > src/money.sh <<'X'
# Money helpers

# format_price <cents> [currency]
format_price() {
  case "${2:-USD}" in EUR) _sym='EUR ' ;; GBP) _sym='GBP ' ;; *) _sym='$' ;; esac
  printf '%s%d.%02d\n' "$_sym" $(($1 / 100)) $(($1 % 100))
}
X
commit "feat(money): format_price takes a currency"
git push -q -u origin feature/multi-currency
day 5
as lena
cat > tests/test_currency.sh <<'X'
. ./src/money.sh
. ./src/currency.sh
[ "$(format_price 1999 EUR)" = 'EUR 19.99' ] || { echo "  format_price 1999 EUR gave $(format_price 1999 EUR)"; exit 1; }
[ "$(convert 1000 GBP)" = '790' ] || { echo "  convert 1000 GBP gave $(convert 1000 GBP)"; exit 1; }
X
commit "test(currency): cover EUR formatting and GBP conversion"
day 9
as dev
append README.md "" "## Multi-currency" "Prices can be shown in USD, EUR or GBP."
commit "docs: describe multi-currency"
git push -q origin feature/multi-currency
remember oldfeature

# ---- meanwhile, three months of main ----
git switch -q main
day 3
as maya
mkdir -p lib
git mv src/money.sh lib/money.sh
git mv src/cart.sh lib/cart.sh
replace tests/test_money.sh "\\.\\/src\\/" ".\\/lib\\/"
commit "refactor: move shell libraries from src/ to lib/"
day 12
as dev
cat > lib/money.sh <<'X'
# Money helpers

# format_price <cents>
format_price() {
  _c=$1; _sign=''
  if [ "$_c" -lt 0 ]; then _sign='-'; _c=$((-_c)); fi
  printf '%s$%d.%02d\n' "$_sign" $((_c / 100)) $((_c % 100))
}
X
append tests/test_money.sh "[ \"\$(format_price -150)\" = '-\$1.50' ] || { echo \"  format_price -150 gave \$(format_price -150)\"; exit 1; }"
commit "fix(money): format refunds (negative amounts)"
day 20
as lena
write lib/search.sh "# Search" "fuzzy() { grep -i \"\$1\"; }"
commit "feat(search): fuzzy product search"
day 25
as jo
append README.md "" "## Search" "Search is fuzzy and case-insensitive."
commit "docs: describe search"
day 18
as maya
append lib/cart.sh "cart_empty() { [ \$# -eq 0 ]; }"
commit "feat(cart): cart_empty helper"
git push -q origin main
remember oldmain
git switch -q feature/multi-currency
as you
