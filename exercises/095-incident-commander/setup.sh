# The SRE's repro script lives outside the repo so it works on every commit bisect checks out.
write repro-checkout.sh \
  "#!/bin/sh" \
  "# INC-311 repro: 'customers can't check out'.  Run from inside repo/:  ../repro-checkout.sh" \
  "# exit 0 = good, 1 = bad, 125 = can't test this commit (git bisect run skips it)" \
  "[ -f src/checkout.sh ] || { echo 'src/checkout.sh missing - cannot test this commit'; exit 125; }" \
  ". ./src/checkout.sh" \
  "can_checkout 1 1999 || { echo 'BROKEN: a 1-item cart cannot check out'; exit 1; }" \
  "can_checkout 3 5000 || { echo 'BROKEN: a 3-item cart cannot check out'; exit 1; }" \
  "if can_checkout 0 0; then echo 'BROKEN: an empty cart can check out'; exit 1; fi" \
  "echo 'checkout OK'"
chmod +x repro-checkout.sh

new_repo repo
write README.md "# Brightcart storefront" "" "Shell-powered demo shop. Logic lives in src/*.sh"
write src/checkout.sh \
  "# Brightcart checkout rules" \
  "MIN_ITEMS=1" \
  "PROVIDER=stripe" \
  "" \
  "# can_checkout <item_count> <total_cents>" \
  "can_checkout() {" \
  "  [ \"\$1\" -ge \"\$MIN_ITEMS\" ] && [ \"\$2\" -gt 0 ]" \
  "}" \
  "" \
  "# tax_for <total_cents>" \
  "tax_for() {" \
  "  echo \$((\$1 * 8 / 100))" \
  "}"
write src/cart.sh "# Cart helpers" "item_count() { echo \"\$#\"; }"
as maya; commit "chore: initial storefront"
git tag -a v3.0.0 -m "Brightcart 3.0.0"

day 2
as lena; write src/search.sh "# Search" "fuzzy() { grep -i \"\$1\"; }"; commit "feat(search): fuzzy product search"
as jo;   mkdir -p src/legacy; git mv src/checkout.sh src/legacy/checkout.sh; commit "chore: move checkout into src/legacy"
as jo;   git mv src/legacy/checkout.sh src/checkout.sh; commit "chore: undo checkout move (broke imports)"
as dev;  replace src/checkout.sh "PROVIDER=stripe" "PROVIDER=paywise"; commit "feat(checkout): switch payment provider to Paywise"
as sam;  append README.md "" "Support: help@brightcart.example"; commit "docs: add support contact"
day 1
as dev;  replace src/checkout.sh '-ge "\$MIN_ITEMS"' '-gt "\$MIN_ITEMS"'; commit "refactor(checkout): use MIN_ITEMS consistently"
remember culprit
as lena; append src/cart.sh "cart_empty() { [ \$# -eq 0 ]; }"; commit "feat(cart): cart_empty helper"
as dev;  replace src/checkout.sh '\* 8 \/ 100' '* 8 \/ 100 + 0'; commit "perf(checkout): simplify tax arithmetic"
as maya; append README.md "" "Release 3.1.0"; commit "chore(release): 3.1.0"
git tag -a v3.1.0 -m "Brightcart 3.1.0"
git branch release/3.1
remember v310

day 1
as lena; write src/loyalty.sh "# Loyalty (3.2)" "points_for() { echo \$((\$1 / 100)); }"; commit "feat(loyalty): earn points (3.2)"
remember loyalty
as dev;  append src/checkout.sh "" "# gift_message <text>" "gift_message() { echo \"Gift: \$1\"; }"; commit "feat(checkout): gift message (3.2)"
as you
