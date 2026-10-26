# feature/search (not pushed) has node_modules/ and dist/ committed in two of its four commits.
new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
write .gitignore ".env" "*.log"
write package.json "{" '  "name": "brightcart",' '  "version": "1.0.0",' '  "dependencies": { "fuzzy-lite": "^2.1.0", "debounce-mini": "^1.0.3" }' "}"
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git
git push -q -u origin main
remember main

git switch -q -c feature/search
as you
write src/search-index.js "// Build a search index" "function buildIndex(products) {" "  return products.map(p => ({ id: p.id, text: p.name.toLowerCase() }));" "}" "module.exports = { buildIndex };"
commit "Add search index"

# commit 2: `npm install && npm run build && git add -A` — oops
write src/search.js "// Product search" "const fuzzy = require('fuzzy-lite');" "function search(index, q) {" "  return index.filter(e => fuzzy.match(q, e.text));" "}" "module.exports = { search };"
write package-lock.json "{" '  "name": "brightcart",' '  "lockfileVersion": 3' "}"
for pkg in fuzzy-lite debounce-mini left-pad is-number kind-of ansi-regex strip-ansi chalk-lite; do
  write "node_modules/$pkg/package.json" "{ \"name\": \"$pkg\", \"version\": \"1.0.0\" }"
  write "node_modules/$pkg/index.js" "module.exports = function $(echo "$pkg" | tr -d '-')() {};"
  write "node_modules/$pkg/README.md" "# $pkg"
  write "node_modules/$pkg/LICENSE" "MIT"
done
write node_modules/.package-lock.json "{}"
write dist/bundle.js "/* minified bundle */ !function(){var a=1;console.log(a)}();"
commit "Add product search"

replace src/search.js "function search\(index, q\) \{" "let timer;\nfunction search(index, q) {"
append src/search.js "function searchDebounced(index, q, cb) { clearTimeout(timer); timer = setTimeout(() => cb(search(index, q)), 200); }"
commit "Debounce search input"

append README.md "" "Search: type in the box, results update after 200 ms."
write dist/bundle.js.map '{"version":3,"sources":["src/search.js"]}'
commit "Document search"

remember original
git log --reverse --format=%s main..HEAD > "$LG_DIR/.lg/subjects"
