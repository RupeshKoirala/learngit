echo merge > ANSWER
cd repo
git switch -q feature/multi-currency
git merge -q main >/dev/null 2>&1 || true
# README: keep both sections
{ echo "# Brightcart storefront"; echo; echo "Shell-powered demo shop. Run ./test.sh"; echo
  echo "## Multi-currency"; echo "Prices can be shown in USD, EUR or GBP."; echo
  echo "## Search"; echo "Search is fuzzy and case-insensitive."; } > README.md
cat > lib/money.sh <<'X'
# Money helpers

# format_price <cents> [currency]
format_price() {
  _c=$1; _sign=''
  if [ "$_c" -lt 0 ]; then _sign='-'; _c=$((-_c)); fi
  case "${2:-USD}" in EUR) _sym='EUR ' ;; GBP) _sym='GBP ' ;; *) _sym='$' ;; esac
  printf '%s%s%d.%02d\n' "$_sign" "$_sym" $((_c / 100)) $((_c % 100))
}
X
git rm -q src/money.sh
replace tests/test_currency.sh "\\.\\/src\\/" ".\\/lib\\/"
git add -A
./test.sh >/dev/null
git commit -q --no-edit
git switch -q main
git merge -q --no-ff --no-edit feature/multi-currency
git push -q origin main feature/multi-currency
