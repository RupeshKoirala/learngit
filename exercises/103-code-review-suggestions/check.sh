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
B=feature/free-shipping
PR=$(pr_for "$B")
expect "a PR from $B exists"                        nonempty "$PR"
if [ -z "$PR" ]; then note "gh pr create --head $B --base main --fill"; finish; fi
STATE=$(pr_json "$PR" state .state)
note "PR #$PR ($STATE): $(pr_json "$PR" url .url)"
REVIEWS=$(ghq "repos/$R/pulls/$PR/reviews" --jq 'length'); [ -n "$REVIEWS" ] || REVIEWS=0
expect "a review was submitted on the PR"           gte "$REVIEWS" 1
LINE=$(ghq "repos/$R/pulls/$PR/comments?per_page=100" --jq '[.[] | select(.path=="src/shipping.js")] | length'); [ -n "$LINE" ] || LINE=0
expect "it has a line comment on src/shipping.js"   gte "$LINE" 1
SUG=$(ghq "repos/$R/pulls/$PR/comments?per_page=100" --jq '[.[] | select(.body | contains("```suggestion"))] | length'); [ -n "$SUG" ] || SUG=0
expect "a review comment contains a \`\`\`suggestion block" gte "$SUG" 1
[ "$LINE" -ge 1 ] 2>/dev/null || note "A plain PR comment (Conversation tab) is not a line comment - comment on a line in Files changed."

REF="$B"; [ "$STATE" = MERGED ] && REF=main
CODE=$(raw src/shipping.js "$REF" || true)
expect "the suggestion is applied: 'total >= FREE_SHIPPING_FROM' on $REF" eval 'printf "%s" "$CODE" | grep -q "total >= FREE_SHIPPING_FROM"'
expect "the old off-by-one 'total > FREE_SHIPPING_FROM' is gone"           eval '[ -n "$CODE" ] && ! printf "%s" "$CODE" | grep -q "total > FREE_SHIPPING_FROM"'

THREADS=$(gh api graphql -F owner="$ME" -F name=learngit-lab -F n="$PR" -f query='
  query($owner:String!,$name:String!,$n:Int!){ repository(owner:$owner,name:$name){ pullRequest(number:$n){
    reviewThreads(first:100){ nodes{ isResolved } } } } }' \
  --jq '.data.repository.pullRequest.reviewThreads.nodes | "\(length) \([.[] | select(.isResolved | not)] | length)"' 2>/dev/null || echo "0 0")
TOTAL=${THREADS% *}; OPEN=${THREADS#* }
expect "there is at least one review thread"        gte "$TOTAL" 1
expect "every review conversation is resolved ($OPEN still open)" eq "$OPEN" 0
[ "$OPEN" = 0 ] || note "Click 'Resolve conversation' under each thread in Files changed / Conversation."
finish
