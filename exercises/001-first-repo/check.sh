cd "$LG_DIR/shop"
# The repository must live in shop/ itself (not in some parent folder that happens to be a repo).
top_is_here() { [ "$(git rev-parse --show-toplevel 2>/dev/null)" = "$(pwd -P)" ]; }
local_cfg()   { [ -n "$(git config --local --get "$1" 2>/dev/null)" ]; }
if ! top_is_here; then nope "shop/ is a Git repository (run git init inside shop/)"; finish; fi
pass "shop/ is a Git repository"
expect "you're on branch main"                          on_branch main
expect "there is at least one commit"                   ref_exists HEAD
expect "user.name is set for this repository (local)"   local_cfg user.name
expect "user.email is set for this repository (local)"  local_cfg user.email
expect ".gitignore is committed"                        in_commit HEAD .gitignore
for f in README.md package.json .env.example src/cart.js src/price.js test.sh; do
  expect "$f is committed"                              in_commit HEAD "$f"
done
expect "node_modules/ was never committed"              history_lacks_path node_modules
expect ".env was never committed"                       history_lacks_path .env
expect "npm-debug.log was never committed"              history_lacks_path npm-debug.log
expect "the ignored files are still on disk"            test -f .env -a -f npm-debug.log -a -d node_modules
expect "the working tree is clean"                      clean_tree
finish
