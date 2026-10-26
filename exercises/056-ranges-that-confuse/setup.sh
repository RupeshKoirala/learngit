# 056 — commit ranges: A..B, A...B, --left-right, --first-parent, ^exclusions, --cherry-pick.

new_bare "$LG_DIR/remotes/origin.git"
new_repo "$LG_DIR/.team/dev"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "// cart: v1.2 tweaks"; commit "Cache cart totals"
as lena; write src/styles.css "body { margin: 0; }"; commit "Add base styles"
git remote add origin "$LG_DIR/remotes/origin.git"
git push -q origin main

# release branch with a version bump and two hotfixes
git switch -q -c release/1.3
as maya; write VERSION "1.3.0"; commit "Bump version to 1.3.0"
as dev;  write src/vat.js "function vat(c) { return Math.round(c * 0.2); }" "module.exports = { vat };"; commit "Fix VAT rounding on invoices"
remember vatfix
as jo;   append src/cart.js "function safeTotal(cart) { return cart.items ? total(cart) : 0; }"; commit "Fix crash on empty cart"
remember crashfix
git push -q origin release/1.3
git switch -q main

# you clone now (before the teammates' next pushes)
cd "$LG_DIR"; git clone -q remotes/origin.git repo; cd repo
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"; git config advice.detachedHead false

# your feature branch, with Lena's UI sub-branch merged in
git switch -q -c feature/gift-cards
as you
write src/giftcard.js "// Gift cards" "function balance(card) { return card.cents; }"; commit "Add gift card model"
append src/giftcard.js "function redeem(card, cents) { card.cents -= cents; }"; commit "Redeem gift cards at checkout"
git switch -q -c lena/gift-card-ui
as lena
write src/giftcard.css ".giftcard { border: 1px dashed; }"; commit "Gift card styles"
append src/giftcard.css ".giftcard .balance { font-weight: bold; }"; commit "Show gift card balance"
git switch -q feature/gift-cards
as you; tick; git merge -q --no-ff -m "Merge branch 'lena/gift-card-ui' into feature/gift-cards" lena/gift-card-ui
append src/giftcard.js "module.exports = { balance, redeem };"; commit "Export gift card API"
git branch -q -D lena/gift-card-ui
remember feature

# two local commits on main you haven't pushed yet
git switch -q main
as you
append README.md "" "## Gift cards (coming soon)"; commit "Announce gift cards in README"
write docs/release-checklist.md "- [ ] tag" "- [ ] notes"; commit "Add release checklist"
remember main

# meanwhile teammates push three commits to main, one is a cherry-pick of the VAT hotfix
cd "$LG_DIR/.team/dev"
as dev;  tick; git cherry-pick "$(cat "$LG_DIR/.lg/vatfix.commit")" >/dev/null
as maya; append src/price.js "// prices are in cents everywhere"; commit "Clarify price units"
as lena; append src/styles.css "a { color: teal; }"; commit "Brand link colour"
git push -q origin main
remember originmain

cd "$LG_DIR/repo"
git fetch -q origin
