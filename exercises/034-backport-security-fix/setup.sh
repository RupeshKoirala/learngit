new_repo repo
brightcart_skeleton
write src/search.js \
  "// Search results" \
  "function renderResult(product) {" \
  "  return '<li class=\"result\">' + product.title + '</li>';" \
  "}" \
  "" \
  "module.exports = { renderResult };"
as maya; commit "Initial storefront"
as bot;  write VERSION "1.3.0"; commit "Release 1.3.0"; git tag v1.3.0
git branch release/1.3
git switch -q release/1.3
as dev;  replace src/price.js "toFixed\(2\)" "toFixed(2).replace('.00', '')"; commit "Hide .00 on whole prices"
as bot;  write VERSION "1.3.2"; commit "Release 1.3.2"; git tag v1.3.2
remember r13

git switch -q main
as lena; replace src/search.js "product\.title" "product.name"; commit "Rename product.title to product.name"
as dev;  write src/stock.js "// Stock levels" "function inStock(item) { return item.stock > 0; }" "module.exports = { inStock };"
         commit "Add stock check"
as bot;  write VERSION "1.4.0"; commit "Release 1.4.0"; git tag v1.4.0
git branch release/1.4
remember r14 release/1.4

as dev;  write src/suggest.js "// Search suggestions" "function suggest(q) { return []; }" "module.exports = { suggest };"
         commit "Add search suggestions"
as maya
write src/html.js \
  "// HTML helpers" \
  "function escapeHtml(s) {" \
  "  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;');" \
  "}" \
  "" \
  "module.exports = { escapeHtml };"
write src/search.js \
  "// Search results" \
  "const { escapeHtml } = require('./html');" \
  "" \
  "function renderResult(product) {" \
  "  return '<li class=\"result\">' + escapeHtml(product.name) + '</li>';" \
  "}" \
  "" \
  "module.exports = { renderResult };"
commit "Escape product names in search results (SEC-112)"
remember fix
as bot;  write VERSION "1.5.0-dev"; commit "Start 1.5 development"
remember main
as you
