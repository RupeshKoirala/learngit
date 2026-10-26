new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

# Dev builds the search API on his branch.
git switch -q -c feature/search-api
as dev
write src/search.js "// Product search" "function search(products, q) {" "  return products.filter(p => p.name.includes(q));" "}" "" "module.exports = { search };"
commit "Add basic product search"
write src/search.js "// Product search" "function search(products, q) {" "  const needle = q.toLowerCase();" "  return products.filter(p => p.name.toLowerCase().includes(needle));" "}" "" "module.exports = { search };"
commit "Make search case-insensitive"
write src/search.js "// Product search" "const MAX_RESULTS = 20;" "" "function search(products, q) {" "  const needle = q.toLowerCase();" "  return products.filter(p => p.name.toLowerCase().includes(needle)).slice(0, MAX_RESULTS);" "}" "" "module.exports = { search };"
commit "Limit search results to 20"
remember api

# You couldn't wait for his PR, so you branched off it to build the UI.
git switch -q -c feature/search-ui
as you
write src/search-ui.js "// Search box" "const { search } = require('./search');" "" "function onInput(products, text, render) {" "  render(search(products, text));" "}" "" "module.exports = { onInput };"
commit "Add search box component"
write src/search-ui.js "// Search box" "const { search } = require('./search');" "" "let timer;" "function onInput(products, text, render) {" "  clearTimeout(timer);" "  timer = setTimeout(() => render(search(products, text)), 200);" "}" "" "module.exports = { onInput };"
commit "Debounce search box input"
remember original

# Dev's PR is approved and Maya lands it with GitHub's "Squash and merge".
git switch -q main
day
as maya
git merge -q --squash feature/search-api >/dev/null
commit "Add product search API (#42)"
as lena; append README.md "" "Support: help@brightcart.example"
commit "Add support email to README"

git switch -q feature/search-ui
