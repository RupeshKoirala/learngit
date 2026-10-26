# Builds the persistent lab ~/learngit-playground/github-lab (only if it doesn't exist; it is never deleted).
LAB="$(cd "$LG_DIR/.." && pwd)/github-lab"
if [ -d "$LAB/.git" ]; then
  printf '\n  Your lab already exists at %s - leaving it untouched.\n' "$LAB"
  if git -C "$LAB" remote get-url origin >/dev/null 2>&1; then
    printf '  It already has an origin (%s). Run ./lg check to verify.\n' "$(git -C "$LAB" remote get-url origin)"
  fi
  exit 0
fi
if [ -d "$LAB" ] && [ -n "$(ls -A "$LAB" 2>/dev/null)" ]; then
  printf '\n  %s exists but is not a git repository. Move it out of the way and run ./lg start 100 again.\n\n' "$LAB"
  exit 1
fi

unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE   # real timestamps: this repo is going to GitHub
labcommit() { git add -A; git commit -q -m "$1"; }

new_repo "$LAB"
brightcart_skeleton
append .gitignore "dist/"
write CHANGELOG.md "# Changelog" "" "## Unreleased" "" "## 0.9.0" "- Cart: add items and compute totals" "- Price formatting"
as maya; labcommit "Initial storefront"

as dev
append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
replace src/cart.js "module.exports = \{ addItem, total \};" "module.exports = { addItem, total, removeItem };"
labcommit "Add removeItem to cart"

as you
write package.json '{' '  "name": "brightcart",' '  "version": "0.9.0",' '  "private": true,' \
  '  "scripts": { "test": "./test.sh", "build": "./build.sh" },' \
  '  "dependencies": {' '    "lodash": "4.17.20"' '  }' '}'
write build.sh "#!/bin/sh" "# Packages the storefront: ./build.sh 1.0.0  ->  dist/brightcart-1.0.0.tar.gz" "set -e" \
  'v=${1:-dev}' "mkdir -p dist" 'tar -czf "dist/brightcart-$v.tar.gz" README.md CHANGELOG.md src' 'echo "built dist/brightcart-$v.tar.gz"'
chmod +x build.sh
labcommit "Add package.json and build script"
