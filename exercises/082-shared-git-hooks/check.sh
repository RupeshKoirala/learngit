# Behavioural check: clone the learner's repo and really attempt commits against the committed hooks.
T="$LG_DIR/.lg/hook-test"
PK_HEAD="-----BEGIN OPENSSH PRIVATE"" KEY-----"   # split so this file never contains the literal header

prepare_clone() {
  rm -rf "$T"
  git clone -q "$LG_DIR/repo" "$T" 2>/dev/null || return 1
  git -C "$T" config user.name "Hook Tester"
  git -C "$T" config user.email "tester@brightcart.example"
  git -C "$T" config core.hooksPath .githooks
  BASE=$(git -C "$T" rev-parse HEAD)
}
# attempt <message> <shell snippet that edits files>   -> succeeds when Git accepts the commit
attempt() {
  ( cd "$T" && git reset -q --hard "$BASE" && git clean -qfdx >/dev/null &&
    eval "$2" && git add -A && git commit -q -m "$1" ) >/dev/null 2>&1
}
same_dir() { [ -d "$1" ] && [ -d "$2" ] && [ "$(cd "$1" && pwd -P)" = "$(cd "$2" && pwd -P)" ]; }
hooks_path_ok() { _h=$(git config core.hooksPath) || return 1; case "$_h" in /*) same_dir "$_h" .githooks ;; *) same_dir "$_h" .githooks ;; esac; }
mode_is_exec() { [ "$(git ls-files -s -- "$1" | cut -c1-6)" = "100755" ]; }
added_conventionally() { git log --diff-filter=A --format=%s -- .githooks/commit-msg | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9._/-]+\))?!?: .+'; }

in_repo
expect "core.hooksPath points this repo at .githooks"                hooks_path_ok
expect ".githooks/pre-commit is committed as executable (100755)"    mode_is_exec .githooks/pre-commit
expect ".githooks/commit-msg is committed as executable (100755)"    mode_is_exec .githooks/commit-msg
expect "the hooks were committed with a Conventional Commits message" added_conventionally
expect "the working tree is clean"                                   clean_tree

if prepare_clone && [ -f "$T/.githooks/pre-commit" ] && [ -f "$T/.githooks/commit-msg" ]; then
  note "trying commits in a fresh clone of your repo…"
  expect_not "blocks an added console.log("            attempt "feat(cart): debug cart" "printf '%s\n' \"console.log('cart', cart);\" >> src/cart.js"
  expect_not "blocks a Stripe live key"                attempt "feat(checkout): configure stripe" "printf '%s\n' \"const KEY = 'sk_live_FAKE123abc';\" >> src/payments.js"
  expect_not "blocks a private key header"             attempt "chore: add deploy key" "mkdir -p deploy && printf '%s\n' '$PK_HEAD' 'b3BlbnNzaC1rZXktdjE=' > deploy/id_ed25519"
  expect     "allows editing scripts/seed.js (existing console.log lines untouched)" \
                                                        attempt "chore(seed): add a third product" "perl -0pi -e \"s/\];/  { id: 3, name: 'Cap', price: 1500 },\n];/\" scripts/seed.js"
  expect     "allows deleting a console.log line"      attempt "chore(seed): drop the TODO log" "perl -0pi -e \"s/console.log\('TODO[^\n]*\n//\" scripts/seed.js"
  expect_not "rejects the message 'fixed stuff'"       attempt "fixed stuff" "printf '%s\n' '// note' >> src/price.js"
  expect_not "rejects 'feat add search' (no colon)"   attempt "feat add search" "printf '%s\n' '// note' >> src/price.js"
  expect_not "rejects 'feature: add search' (unknown type)" attempt "feature: add search" "printf '%s\n' '// note' >> src/price.js"
  expect     "accepts 'feat(cart): add bulk discount'" attempt "feat(cart): add bulk discount" "printf '%s\n' '// bulk' >> src/cart.js"
  expect     "accepts 'fix!: drop legacy coupon codes'" attempt "fix!: drop legacy coupon codes" "printf '%s\n' '// coupons' >> src/price.js"
  expect     "accepts \"Merge branch 'release/1.2'\""  attempt "Merge branch 'release/1.2'" "printf '%s\n' '// merge' >> src/price.js"
else
  nope "both hooks are committed, so a fresh clone gets them"
fi
rm -rf "$T"
finish
