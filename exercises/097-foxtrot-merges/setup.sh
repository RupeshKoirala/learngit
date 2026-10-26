# pr <number> <branch> <author> <file> <line> <message>   a GitHub-style PR merged by Maya and pushed
pr() {
  git pull -q --no-rebase origin main
  git switch -q -c "$2"
  as "$3"; append "$4" "$5"; commit "$6"
  git switch -q main
  as maya; tick; git merge -q --no-ff -m "Merge pull request #$1 from brightcart/$2" "$2"
  git branch -q -D "$2"
  git push -q origin main
}
PULLMSG="Merge branch 'main' of github.com:brightcart/storefront"

new_bare "$LG_DIR/remotes/origin.git"
ORIGIN="$LG_DIR/remotes/origin.git"

# Maya's clone: the GitHub "merge button"
new_repo "$LG_DIR/.team/maya"
git remote add origin "$ORIGIN"
brightcart_skeleton
write src/footer.txt "Brightcart - shop happy" "Contact: help@brightcart.example"
as maya; commit "chore: initial storefront"
git push -q -u origin main
pr 50 search-box lena src/search.js "// search box" "feat(search): search box in header"

# Jo clones and commits straight on main (new hire...)
git clone -q "$ORIGIN" "$LG_DIR/.team/jo"
cd "$LG_DIR/.team/jo"
as jo; replace src/footer.txt "shop happy" "shop happily"; commit "Fix typo in footer"

cd "$LG_DIR/.team/maya"
pr 51 loyalty dev src/loyalty.js "// loyalty points" "feat(loyalty): earn points on every order"

# Jo pushes: rejected -> plain `git pull` (merge) -> push. The foxtrot lands on origin.
cd "$LG_DIR/.team/jo"
as jo; tick
git pull -q --no-rebase --no-edit origin main
git commit -q --amend -m "$PULLMSG"
git push -q origin main
remember foxtrot

cd "$LG_DIR/.team/maya"
pr 52 wishlist lena src/wishlist.js "// wishlist" "feat(wishlist): save items for later"

# You clone and make a change on main
cd "$LG_DIR"
git clone -q "$ORIGIN" repo
cd repo
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git config pull.rebase false
as you; write src/shipping.txt "Free shipping from \$50"; commit "Update shipping copy"
remember mine

cd "$LG_DIR/.team/maya"
pr 53 coupons dev src/coupons.js "// coupons" "feat(coupons): percentage coupons"
remember upstream

# ...and you already ran `git pull` — another foxtrot, this time only local
cd "$LG_DIR/repo"
as you; tick
git pull -q --no-edit origin main
git commit -q --amend -m "$PULLMSG"
as you
