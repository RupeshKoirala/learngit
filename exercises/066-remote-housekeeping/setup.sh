R="$LG_DIR/remotes/origin.git"
mkdir -p "$R"; git init -q --bare -b master "$R"     # an older repo: default branch is master

new_repo "$LG_DIR/.team/maya"
git branch -M master
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin "$R"
git push -q -u origin master

git switch -q -c feature/gift-cards
as lena; write src/giftcard.js "// Gift cards" "function redeem(card, total) {" "  return Math.max(0, total - card.balance);" "}" "" "module.exports = { redeem };"
commit "Add gift card redemption"
git push -q -u origin feature/gift-cards
git switch -q -c fix/old-tax master
as dev; write src/tax.js "// Sales tax" "function tax(cents) {" "  return Math.round(cents * 0.0725);" "}" "" "module.exports = { tax };"
commit "Round sales tax"
git push -q -u origin fix/old-tax
git switch -q -c spike/old-checkout master
as you; write src/checkout2.js "// Spike: one-page checkout (abandoned)"
commit "Spike: one-page checkout"
git push -q -u origin spike/old-checkout
git switch -q master

# You clone and help Lena on her branch.
cd "$LG_DIR"
git clone -q "$R" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git switch -q feature/gift-cards
git switch -q master

# The team merges both PRs and deletes their branches on the server.
cd "$LG_DIR/.team/maya"
day 2
as maya
git merge -q --no-ff -m "Merge pull request #12 from feature/gift-cards" feature/gift-cards
git merge -q --no-ff -m "Merge pull request #13 from fix/old-tax" fix/old-tax
git push -q origin master
git push -q origin --delete feature/gift-cards fix/old-tax
remember master_tip

# You update master (a plain fetch doesn't prune).
cd "$LG_DIR/repo"
git fetch -q --no-prune
git merge -q --ff-only origin/master
