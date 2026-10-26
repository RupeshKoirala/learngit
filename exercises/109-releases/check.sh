# ---- module 12: checks ask GitHub through gh ------------------------------------------------------------
LAB="$(cd "$LG_DIR/.." && pwd)/github-lab"
gh_ready() { command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; }
if ! gh_ready; then nope "gh is installed and logged in"; note "Run: gh auth login"; finish; fi
ME=$(gh api user -q .login 2>/dev/null || true); R="$ME/learngit-lab"
if ! gh api "repos/$R" >/dev/null 2>&1; then nope "github.com/$R exists"; note "Do exercise 100 first: ./lg start 100"; finish; fi
if [ -d "$LAB/.git" ]; then cd "$LAB"; fi
ghq()     { gh api "$@" 2>/dev/null || true; }                  # quiet gh api: prints nothing on error
raw()     { gh api -H 'Accept: application/vnd.github.raw+json' "repos/$R/contents/$1?ref=${2:-main}" 2>/dev/null; }
pr_for()  { gh pr list --repo "$R" --head "$1" --state all --json number --jq '.[0].number // empty' 2>/dev/null || true; }
pr_json() { gh pr view "$1" --repo "$R" --json "$2" --jq "$3" 2>/dev/null || true; }
gte()     { [ -n "$1" ] && [ "$1" -ge "$2" ] 2>/dev/null; }
eq()      { [ "$1" = "$2" ]; }
nonempty(){ [ -n "$1" ]; }
# ---------------------------------------------------------------------------------------------------------
TYPE=$(ghq "repos/$R/git/ref/tags/v1.0.0" --jq .object.type)
expect "tag v1.0.0 exists on GitHub"                  nonempty "$TYPE"
expect "v1.0.0 is an annotated tag (not lightweight)" eq "$TYPE" tag
[ "$TYPE" = commit ] && note "Lightweight tag. Recreate: git tag -d v1.0.0; git push origin :v1.0.0; git tag -a v1.0.0 -m '...'"
ON_MAIN=$(ghq "repos/$R/compare/v1.0.0...main" --jq .status)
expect "v1.0.0 points at a commit on main"            eval 'case "$ON_MAIN" in identical|ahead) true;; *) false;; esac'
expect "the tag exists locally too"                   tag_exists v1.0.0

REL() { gh release view v1.0.0 --repo "$R" --json "$1" --jq "$2" 2>/dev/null || true; }
expect "a GitHub Release for v1.0.0 exists"           nonempty "$(REL tagName .tagName)"
expect "it is published (not a draft)"                eq "$(REL isDraft .isDraft)" false
expect "it has a title"                               nonempty "$(REL name .name)"
notes_ok() { REL body .body | grep -qE "What's Changed|Full Changelog|New Contributors"; }
expect "it has generated release notes"               notes_ok
ASSET=$(REL assets '.assets[].name' | grep -E '^brightcart-.*\.tar\.gz$' | head -1)
expect "a brightcart-*.tar.gz build is attached"      nonempty "$ASSET"
[ -n "$ASSET" ] && note "asset: $ASSET   ($(REL url .url))"
finish
