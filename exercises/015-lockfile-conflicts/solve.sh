cd repo
git switch -q feature/review-markdown
git merge -q main >/dev/null 2>&1 || true
git checkout -q --theirs package-lock.json
./tools/lock.sh >/dev/null
git add package-lock.json
write src/product-page.js "// Product page" "const dayjs = require('dayjs');" "const { marked } = require('marked');" "" \
  "function renderReview(review) {" \
  "  return '<p>' + marked.parseInline(review.text) + '</p><small>' + dayjs(review.date).format('MMM D, YYYY') + '</small>';" \
  "}" "" "module.exports = { renderReview };"
git add src/product-page.js
git commit -q --no-edit
