cd repo
fix=$(git log --format=%H --grep=SEC-112 main)
git switch -q release/1.4
git cherry-pick -x "$fix" >/dev/null
git tag -a v1.4.1 -m "1.4.1: SEC-112"
git switch -q release/1.3
git cherry-pick -x "$fix" >/dev/null 2>&1 || true
write src/search.js \
  "// Search results" \
  "const { escapeHtml } = require('./html');" \
  "" \
  "function renderResult(product) {" \
  "  return '<li class=\"result\">' + escapeHtml(product.title) + '</li>';" \
  "}" \
  "" \
  "module.exports = { renderResult };"
git add src/search.js
git cherry-pick --continue >/dev/null
git tag v1.3.3
