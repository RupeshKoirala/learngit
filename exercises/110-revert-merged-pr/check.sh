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
ORIG=$(gh pr list --repo "$R" --head feature/express-checkout --state merged --json number,mergedAt --jq '.[0] | "\(.number) \(.mergedAt)"' 2>/dev/null || true)
ON=${ORIG%% *}; OT=${ORIG#* }
expect "the express checkout PR was merged"                  nonempty "$ON"
[ -n "$ON" ] || { note "gh pr create --head feature/express-checkout --base main --fill && gh pr merge --squash"; finish; }

# the revert: merged after the original, title starts with Revert, mentions the PR or its title
OTITLE=$(pr_json "$ON" title .title)
MERGED=$(gh pr list --repo "$R" --state merged --limit 100 --json number,title,body,mergedAt \
  --jq ".[] | select(.mergedAt > \"$OT\") | \"\(.mergedAt)\t\(.number)\t\(.title)\t\((.body // \"\") | gsub(\"[\\n\\t]\"; \" \"))\"" 2>/dev/null | sort || true)
REV=$(printf '%s\n' "$MERGED" | awk -F '\t' -v n="#$ON" -v t="$OTITLE" 'tolower($3) ~ /^revert/ && (index($3, t) || index($4, n)) {print $1 "\t" $2; exit}')
RT=$(printf '%s' "$REV" | cut -f1); RN=$(printf '%s' "$REV" | cut -f2)
expect "a 'Revert ...' PR undoing #$ON was merged after it"  nonempty "$RN"
[ -n "$RN" ] && note "revert: #$RN"

touches_express() { pr_json "$1" files '.files[].path' | grep -qx src/express.js; }
RELAND=""
if [ -n "$RT" ]; then
  for n in $(printf '%s\n' "$MERGED" | awk -F '\t' -v t="$RT" '$1 > t && tolower($3) !~ /^revert/ {print $2}'); do
    if touches_express "$n"; then RELAND=$n; break; fi
  done
fi
expect "a later PR re-landed src/express.js"                 nonempty "$RELAND"
[ -n "$RELAND" ] && note "re-land: #$RELAND"
CODE=$(raw src/express.js main || true)
expect "main has src/express.js again"                       nonempty "$CODE"
expect "it defines validateAddress"                          eval 'printf "%s" "$CODE" | grep -qE "function validateAddress|validateAddress *="'
expect "expressCheckout uses validateAddress(...)"           eval 'printf "%s" "$CODE" | grep -qE "address: *validateAddress\("'
finish
