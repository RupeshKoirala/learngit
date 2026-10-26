RD="$LG_DIR/remotes"
new_bare "$RD/origin.git"
new_bare "$RD/backup.git"            # brand-new, empty backup server
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function isEmpty(cart) {" "  return cart.items.length === 0;" "}"; commit "Add isEmpty to cart"
git remote add origin "$RD/origin.git"
git push -q -u origin main
# The old GitLab mirror (since moved to a new address) and an old Heroku deploy remote.
git clone -q --bare "$RD/origin.git" "$RD/legacy.git"
git clone -q --bare "$RD/origin.git" "$RD/heroku.git"

cd "$LG_DIR"
git clone -q "$RD/origin.git" repo
cd "$LG_DIR/repo"
git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"
git remote add gitlab "$RD/legacy.git";  git fetch -q gitlab
git remote set-url gitlab "$RD/gitlab-old.git"      # the old address, which no longer exists
git remote add heroku "$RD/heroku.git";  git fetch -q heroku
as you
write docs/returns.md "# Returns" "" "Unused items can be returned within 30 days."
commit "Add returns policy page"
remember mine
git rev-parse main~1 > "$LG_DIR/.lg/legacy_main"
