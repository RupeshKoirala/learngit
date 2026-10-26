# shellcheck shell=bash
# Helpers for exercise setup.sh scripts. Sourced by `lg` before running an exercise's setup.sh.
# Must stay compatible with bash 3.2 (the default /bin/bash on macOS): no associative arrays,
# no ${var,,}, no mapfile, no `sed -i`.
#
# Contract: setup.sh runs with the current directory = the exercise sandbox ($LG_DIR), which is empty.
# By convention the learner works in $LG_DIR/repo; fake remotes live in $LG_DIR/remotes/<name>.git.

set -e

# ---- fake clock: every commit gets a predictable, increasing timestamp --------------------------------
LG_CLOCK=${LG_CLOCK:-1735725600}   # 2025-01-01 10:00 UTC
tick() {                          # tick [seconds]   (default: 47 minutes)
  LG_CLOCK=$((LG_CLOCK + ${1:-2820}))
  export GIT_AUTHOR_DATE="@$LG_CLOCK +0000" GIT_COMMITTER_DATE="@$LG_CLOCK +0000"
}
day() { tick $((86400 * ${1:-1})); }   # jump forward N days

# ---- people at Brightcart (a fictional online store) ---------------------------------------------------
# `as <who>` makes the following commits authored + committed by that person.
as() {
  case "$1" in
    you)   _n="$LG_LEARNER_NAME";  _e="$LG_LEARNER_EMAIL" ;;
    maya)  _n="Maya Chen";         _e="maya@brightcart.example" ;;      # tech lead
    dev)   _n="Dev Patel";         _e="dev@brightcart.example" ;;       # backend dev
    lena)  _n="Lena Okafor";       _e="lena@brightcart.example" ;;      # frontend dev
    sam)   _n="Sam Rivera";        _e="sam@brightcart.example" ;;       # product manager
    jo)    _n="Jo Novak";          _e="jo@brightcart.example" ;;        # new hire
    bot)   _n="release-bot";       _e="bot@brightcart.example" ;;
    *)     echo "as: unknown person '$1'" >&2; return 1 ;;
  esac
  export GIT_AUTHOR_NAME="$_n" GIT_AUTHOR_EMAIL="$_e" GIT_COMMITTER_NAME="$_n" GIT_COMMITTER_EMAIL="$_e"
}

# ---- files ---------------------------------------------------------------------------------------------
write() {    # write <path> <line>...      (overwrites; each extra arg is one line)
  _p="$1"; shift
  mkdir -p "$(dirname "$_p")"
  if [ $# -eq 0 ]; then : > "$_p"; else printf '%s\n' "$@" > "$_p"; fi
}
append() {   # append <path> <line>...
  _p="$1"; shift
  mkdir -p "$(dirname "$_p")"
  printf '%s\n' "$@" >> "$_p"
}
replace() {  # replace <path> <perl-regex> <replacement>    (portable in-place edit via perl)
  perl -0pi -e "s/$2/$3/g" "$1"
}

# ---- git -------------------------------------------------------------------------------------------------
new_repo() {   # new_repo <dir>   creates a repo on branch main and cds into it
  mkdir -p "$1"; cd "$1"
  git init -q -b main .
  git config user.name "$LG_LEARNER_NAME"
  git config user.email "$LG_LEARNER_EMAIL"
  git config advice.detachedHead false
}
new_bare() {   # new_bare <path.git>   (a fake GitHub remote)
  mkdir -p "$1"; git init -q --bare -b main "$1"
}
commit() {     # commit <message> [--allow-empty]   stages everything and commits with the next tick
  tick
  git add -A
  git commit -q -m "$1" ${2:+"$2"}
}
commit_staged() { tick; git commit -q -m "$1"; }   # commit only what is already staged
ensure_identity() { git config user.name "$LG_LEARNER_NAME"; git config user.email "$LG_LEARNER_EMAIL"; }

# A small realistic project skeleton most exercises start from.
brightcart_skeleton() {
  write README.md "# Brightcart storefront" "" "Tiny demo shop used for Git practice." "" "Run the tests with ./test.sh"
  write src/cart.js \
    "// Shopping cart" \
    "function addItem(cart, item) {" \
    "  cart.items.push(item);" \
    "  return cart;" \
    "}" \
    "" \
    "function total(cart) {" \
    "  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);" \
    "}" \
    "" \
    "module.exports = { addItem, total };"
  write src/price.js \
    "// Price formatting" \
    "function formatPrice(cents) {" \
    "  return '\$' + (cents / 100).toFixed(2);" \
    "}" \
    "" \
    "module.exports = { formatPrice };"
  write test.sh "#!/bin/sh" "# fake test runner: fails if a known bug marker is present" \
    "if grep -rq 'BUG' src; then echo 'tests FAILED'; exit 1; fi" "echo 'tests passed'"
  chmod +x test.sh
  write .gitignore "node_modules/" ".env" "*.log"
}

# Everyone starts from the same identity so commit authors are predictable.
as you
tick 0

# remember <name> [rev]   saves a commit's hash and tree hash outside the repo (in $LG_DIR/.lg) so check.sh
# can compare against the starting state without leaving visible refs in the learner's repo.
remember() {
  mkdir -p "$LG_DIR/.lg"
  git rev-parse "${2:-HEAD}^{commit}" > "$LG_DIR/.lg/$1.commit"
  git rev-parse "${2:-HEAD}^{tree}"   > "$LG_DIR/.lg/$1.tree"
}
