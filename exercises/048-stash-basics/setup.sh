new_repo repo
brightcart_skeleton
write src/payment.js "// Payments" "function charge(gateway, order) {" "  return gateway.charge(order);" "}" "" "module.exports = { charge };"
as maya; commit "Initial storefront"
git switch -q -c feature/search
as you
write src/search.js "// Product search" "function search(products, q) {" "  return products.filter(p => p.name.includes(q));" "}" "" "module.exports = { search };"
commit "Add basic product search"
remember head

# an old, unnamed stash from a debugging session two weeks ago
replace src/payment.js "  return gateway.charge\(order\);" "  console.log('DEBUG order', order);\n  return gateway.charge(order);"
tick; git stash -q
# a named experiment from last week
replace src/search.js "  return products.filter\(p => p.name.includes\(q\)\);" "  \/\/ experiment: tolerate typos\n  return products.filter(p => levenshtein(p.name, q) <= 2);"
tick; git stash push -q -m "experiment: fuzzy matching"

# what you're in the middle of right now
replace src/search.js "  return products.filter\(p => p.name.includes\(q\)\);" "  const hits = products.filter(p => p.name.includes(q));\n  return rankResults(hits, q); \/\/ TODO: rankResults"
write src/search-ui.js "// Search box (not tracked yet)" "function renderSearchBox() { return '<input type=\"search\">'; }"
