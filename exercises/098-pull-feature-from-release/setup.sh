g() { remember "gift$1"; }   # mark the last commit as gift-card commit N

new_repo repo
write README.md "# Brightcart storefront" "" "Shell-powered demo shop."
write VERSION "2.2.0"
write src/checkout.sh \
  "# Checkout" \
  "checkout() {" \
  "  total=\$1" \
  "  # discounts" \
  "  total=\$(apply_coupon \"\$total\")" \
  "" \
  "" \
  "" \
  "  # tax" \
  "  tax=\$((total * 8 / 100))" \
  "  echo \$((total + tax))" \
  "}"
write src/header.sh "# Header" "header() {" "  echo 'Brightcart'" "" "" "  echo \"Cart: \$1 items\"" "}"
write src/search.sh "# Search" "search() { grep -i \"\$1\"; }"
as maya; commit "chore(release): 2.2.0"
git tag -a v2.2.0 -m "Brightcart 2.2.0"

day 1
as lena; write src/giftcards.sh "# Gift cards" "giftcard_balance() { echo \"\${GIFT_BALANCE:-0}\"; }"
commit "feat(giftcards): gift card model"; g 1
as dev;  write src/search.sh "# Search" "search() { grep -i \"\$1\" | head -50; }"
commit "feat(search): typo tolerance"
as lena; replace src/checkout.sh '\$total"\)\n\n' '\$total")\n  total=\$(apply_giftcard "\$total")\n'
commit "feat(giftcards): apply gift card at checkout"; g 2
as dev;  write src/saved_cards.sh "# Saved payment cards" "saved_cards() { cat \"\$HOME/.cards\"; }"
commit "feat(cards): remember saved payment cards"
day 1
as lena; append src/giftcards.sh "giftcard_charge() { b=\$((\$(giftcard_balance) - \$1)); [ \$b -lt 0 ] && b=0; echo \$b; }"
commit "fix(giftcards): balance can't go negative"; g 3
as dev;  replace src/checkout.sh 'total \* 8 \/ 100' '(total * 8 + 50) \/ 100'
commit "fix(checkout): round tax correctly"
as jo;   write tests/test_giftcards.sh ". ./src/giftcards.sh" "[ \"\$(GIFT_BALANCE=500 giftcard_balance)\" = 500 ] || exit 1"
commit "test(giftcards): balance tests"; g 4
as sam;  append README.md "" "Questions? help@brightcart.example"
commit "docs: support contact in README"
day 1
as lena; write templates/giftcard_email.txt "Someone sent you a Brightcart gift card!"
append src/giftcards.sh "giftcard_email() { cat templates/giftcard_email.txt; }"
commit "feat(giftcards): gift card email template"; g 5
as dev;  write src/search.sh "# Search" "search() { grep -i \"\$1\" | sort -u | head -50; }"
commit "perf(search): dedupe results"
as lena; replace src/header.sh "'Brightcart'\n\n" "'Brightcart'\n  echo \"Gift card: \$(giftcard_balance)\"\n"
commit "feat(giftcards): show gift card balance in header"; g 6
as maya; write VERSION "2.3.0-rc1"
commit "chore(release): 2.3.0-rc1"
git branch release/2.3

day 1
as lena; append src/giftcards.sh "giftcard_refund() { echo refunded; }"
commit "feat(giftcards): refunds to gift card"
as dev;  write src/reviews.sh "# Reviews" "stars() { echo '*****'; }"
commit "feat(reviews): star ratings"
remember main

git switch -q release/2.3
as maya; write src/search.sh "# Search" "search() { [ -n \"\$1\" ] || return 0; grep -i \"\$1\" | sort -u | head -50; }"
commit "fix(search): empty query no longer crashes"
remember release

# expected end state: release/2.3 with the six gift-card commits reverted (newest first)
git revert -n $(for n in 6 5 4 3 2 1; do cat "$LG_DIR/.lg/gift$n.commit"; done) >/dev/null
git write-tree > "$LG_DIR/.lg/expected.tree"
git reset -q --hard
as you
