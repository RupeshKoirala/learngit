keep_everything() {
  git config gc.auto 0
  git config gc.reflogExpire never
  git config gc.reflogExpireUnreachable never
  git config gc.pruneExpire never
}

new_repo repo
keep_everything
brightcart_skeleton
as maya; commit "Initial storefront"
remember main

as you
git switch -q -c feature/reviews
write src/reviews/page.html "<h1>Custmer reviews</h1>" "<section id=\"reviews\"></section>" "<!-- form goes here -->"
commit "Add reviews page skeleton"
write src/reviews/form.js "// Review form" "function submitReview(text) {" "  return { text: text.trim() };" "}" "" "module.exports = { submitReview };"
commit "Add review form"
write src/reviews/rating.js "// Star rating widget" "function stars(n) {" "  return '*'.repeat(n) + '-'.repeat(5 - n);" "}" "" "module.exports = { stars };"
commit "Add star rating widget"
write src/reviews/moderation.js "// Moderation queue" "const queue = [];" "function flag(review) {" "  queue.push(review);" "}" "" "module.exports = { flag, queue };"
commit "Add review moderation queue"
remember lost

# You meant `git reset --soft HEAD~1`…
git reset -q --hard HEAD~2
# …didn't notice, and kept working
replace src/reviews/page.html "Custmer" "Customer"
commit "Fix typo in reviews header"
remember fix
