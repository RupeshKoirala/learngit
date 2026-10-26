crlf() { _p="$1"; shift; mkdir -p "$(dirname "$_p")"; printf '%s\r\n' "$@" > "$_p"; }   # Windows line endings

new_repo repo
brightcart_skeleton
write scripts/deploy.sh "#!/bin/sh" "set -e" "echo 'deploying storefront…'"
chmod +x scripts/deploy.sh
write tests/cart.test.js "// cart tests" "require('../src/cart');"
write .github/workflows/ci.yml "name: ci" "on: [push]" "jobs:" "  test:" "    runs-on: ubuntu-latest" "    steps:" "      - run: ./test.sh"
mkdir -p assets
printf '\211PNG\r\n\032\n\000\000\000\rIHDR\000\000\000\001\000\000\000\001\010\002\000\000\000\220wS\336\r\n' > assets/logo.png
as maya; commit "chore: initial storefront"

as bot
mkdir -p dist
perl -e 'print "!function(){var c={items:[]};", join(";", map { "function f$_(a){return a*$_}" } 1..120), "}();\n"' > dist/app.min.js
commit "build: bundle dist/app.min.js"

# Jo is on Windows with core.autocrlf=false: CRLF files go straight into the repo.
as jo
crlf src/checkout.js "// Checkout" "function checkout(cart) {" "  return { ok: true, total: cart.items.length };" "}" "" "module.exports = { checkout };"
crlf scripts/install.bat "@echo off" "echo Installing Brightcart dev tools" "npm install"
crlf scripts/deploy.sh "#!/bin/sh" "set -e" "echo 'deploying storefront…'"
crlf src/price.js "// Price formatting" "function formatPrice(cents) {" "  return '\$' + (cents / 100).toFixed(2);" "}" "" "module.exports = { formatPrice };"
crlf docs/setup.md "# Local setup" "" "1. Install Node 20"
printf '%s\n' "2. Run scripts/install.bat (Windows) or npm install" "3. Run ./test.sh" >> docs/setup.md
commit "feat(checkout): add checkout + Windows install script"

as bot
perl -pi -e 's/f120\(a\)\{return a\*120\}/f120(a){return a*121}/' dist/app.min.js
commit "build: rebuild dist/app.min.js"
remember before
as you
