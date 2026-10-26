# Deterministic "binary" blob of ~80 KB (stands in for product images / design files).
blob() { mkdir -p "$(dirname "$2")"; perl -e 'srand($ARGV[0]); print map { chr(int(rand(256))) } 1..80000' "$1" > "$2"; }

new_bare "$LG_DIR/remotes/monorepo.git"
new_repo "$LG_DIR/.team/monorepo"
as maya
write README.md "# Brightcart monorepo" "" "services/  backend services (one folder per team)" "web/       storefront frontend" "assets/    product images (large)"
write CODEOWNERS "/services/payments/ @dev" "/services/catalog/ @lena" "/services/search/ @maya" "/web/ @lena"
write .gitignore "node_modules/" ".env"
commit "chore: monorepo layout"
as dev
write services/payments/README.md "# payments" "" "Charges cards and retries failed captures."
write services/payments/index.js "const { withRetry } = require('./retry');" "module.exports = { charge: (c) => withRetry(() => ({ ok: true, cents: c })) };"
write services/payments/retry.js "// Retry policy for card captures" "const TIMEOUT_MS = 5000;" "const ATTEMPTS = 3;" "" "function withRetry(fn) {" "  return fn();" "}" "" "module.exports = { withRetry, TIMEOUT_MS, ATTEMPTS };"
commit "feat(payments): add payments service"
as lena
write services/catalog/index.js "module.exports = { list: () => [] };"
write web/index.html "<!doctype html><title>Brightcart</title>"
commit "feat(catalog): add catalog service and web shell"
as maya
write services/search/index.js "module.exports = { search: (q) => [] };"
commit "feat(search): add search service"
i=1
while [ $i -le 6 ]; do
  as lena; blob $i assets/catalog-images.bin; blob $((i + 100)) assets/hero-banner.bin
  commit "chore(assets): refresh product images (batch $i)"
  i=$((i + 1))
done
git remote add origin "$LG_DIR/remotes/monorepo.git"
git push -q origin main

cd "$LG_DIR"
git clone -q "$LG_DIR/remotes/monorepo.git" repo
cd repo
ensure_identity
as you
