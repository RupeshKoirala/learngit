# ---- module 12 lab helpers: one persistent GitHub lab, next to the exercise sandboxes -------------------
LAB="$(cd "$LG_DIR/.." && pwd)/github-lab"
lab_git() { env -u GIT_CONFIG_GLOBAL -u GIT_CONFIG_NOSYSTEM git "$@"; }   # your real git config = your GitHub credentials
stop() { printf '\n  %s\n\n' "$*"; exit 1; }
{ [ -d "$LAB/.git" ] && git -C "$LAB" remote get-url origin >/dev/null 2>&1; } \
  || stop "Your GitHub lab isn't set up yet - do exercise 100 first:  ./lg start 100"
command -v gh >/dev/null 2>&1 || stop "This exercise needs the GitHub CLI: brew install gh && gh auth login"
gh auth status >/dev/null 2>&1 || stop "gh isn't logged in yet. Run: gh auth login"
ME=$(gh api user -q .login); R="$ME/learngit-lab"
gh api "repos/$R" >/dev/null 2>&1 || stop "github.com/$R doesn't exist yet - finish exercise 100 first:  ./lg start 100"
cd "$LAB"
unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE      # real timestamps: this repo lives on GitHub
export GH_PROMPT_DISABLED=1
_gd=$(git rev-parse --git-dir)
{ [ ! -d "$_gd/rebase-merge" ] && [ ! -d "$_gd/rebase-apply" ] && [ ! -f "$_gd/MERGE_HEAD" ]; } \
  || stop "A rebase/merge is still in progress in $LAB. Finish or abort it first."
[ -z "$(git status --porcelain)" ] || stop "Your lab has uncommitted changes. Commit or stash them first:  cd $LAB && git status"
lab_git fetch -q --prune origin || stop "Couldn't fetch from GitHub. Try: gh auth setup-git"
git switch -q main
git merge -q --ff-only origin/main 2>/dev/null || echo "  (note: your local main has diverged from origin/main - left as it is)"
labcommit() { git add -A; git commit -q -m "$1"; }
seed_branch() { git switch -q -C "$1" origin/main; }           # a fresh scenario branch from GitHub's main
publish() {                                                    # force-push a scenario branch, go back to main
  lab_git push -q -f -u origin "$1" >/dev/null 2>&1 || stop "Couldn't push $1 to GitHub. Try: gh auth setup-git"
  git switch -q main
}
# ---------------------------------------------------------------------------------------------------------
# all three merge buttons must be available for this exercise
gh repo edit "$R" --enable-merge-commit --enable-squash-merge --enable-rebase-merge >/dev/null 2>&1 \
  || echo "  (couldn't enable all merge methods - check Settings -> General -> Pull Requests)"

seed_branch demo/merge-commit; as dev
write src/wishlist.js "// Wishlist" "function addToWishlist(list, id) {" "  return list.includes(id) ? list : list.concat(id);" "}"
labcommit "Add wishlist module"
append src/wishlist.js "" "module.exports = { addToWishlist };"
labcommit "Export wishlist helpers"
publish demo/merge-commit

seed_branch demo/squash; as lena
write src/reviews.js "// Product reviews" "function averageRating(reviews) {" "  if (!reviews.length) return 0;" "  return reviews.reduce((s, r) => s + r.stars, 0) / reviews.lenght;" "}"
labcommit "Add product reviews"
replace src/reviews.js "lenght" "length"
append src/reviews.js "" "module.exports = { averageRating };"
labcommit "fix typo"
publish demo/squash

seed_branch demo/rebase; as maya
write src/search.js "// Product search" "function search(products, q) {" "  return products.filter(p => p.name.includes(q));" "}" "" "module.exports = { search };"
labcommit "Add product search"
replace src/search.js "p\.name\.includes\(q\)" "p.name.toLowerCase().includes(q.toLowerCase())"
labcommit "Search is case-insensitive"
publish demo/rebase
as you
printf '\n  Pushed demo/merge-commit, demo/squash and demo/rebase (2 commits each).\n'
