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
B=review/loyalty-points
alias_ok() { gh alias list 2>/dev/null | grep -E '^prs:' | grep -q 'pr list'; }
expect "gh alias 'prs' expands to 'pr list ...'"       alias_ok
alias_ok || note "gh alias set prs 'pr list --author @me'"

expect "local branch $B exists (gh pr checkout)"       branch_exists "$B"
expect "it tracks origin/$B"                           eq "$(upstream_of "$B")" "origin/$B"

HEAD_SHA=$(ghq "repos/$R/branches/$B" --jq .commit.sha)
PR=$(pr_for "$B"); STATE=$(pr_json "$PR" state .state)
REF=$B; [ -z "$HEAD_SHA" ] && [ "$STATE" = MERGED ] && REF=main
CODE=$(raw src/loyalty.js "$REF" || true)
expect "pointsFor returns whole points (Math.floor) on $REF" eval 'printf "%s" "$CODE" | grep -qE "Math\.(floor|trunc)"'
if [ -n "$HEAD_SHA" ]; then
  expect "you pushed a new commit to $B"               eval '[ "$HEAD_SHA" != "$(saved seed)" ]'
  GREEN=$(gh run list --repo "$R" --branch "$B" -L 50 --json headSha,conclusion \
            --jq "[.[] | select(.headSha==\"$HEAD_SHA\" and .conclusion==\"success\")] | length" 2>/dev/null || true)
  expect "CI is green for your latest commit on $B"    gte "$GREEN" 1
  gte "$GREEN" 1 || note "gh run list --branch $B ; gh run watch   (still running? check again in a minute)"
fi

MERGED=$(gh pr list --repo "$R" --state merged --limit 1000 --json number --jq length 2>/dev/null || true)
file_is() { [ -f "$LG_DIR/$1" ] && [ "$(tr -d ' \n\r\t' < "$LG_DIR/$1" | tr 'A-Z' 'a-z')" = "$(printf '%s' "$2" | tr 'A-Z' 'a-z')" ]; }
expect "merged-prs holds the number of merged PRs in your lab" file_is merged-prs "$MERGED"
file_is merged-prs "$MERGED" || note "file: $LG_DIR/merged-prs (GitHub says ${MERGED:-?} right now; merging another PR changes it)"
TOP=$(gh search repos --owner octocat --sort stars --order desc --limit 1 --json fullName --jq '.[0].fullName' 2>/dev/null || true)
expect "top-octocat-repo names octocat's most-starred repo" file_is top-octocat-repo "$TOP"
file_is top-octocat-repo "$TOP" || note "file: $LG_DIR/top-octocat-repo"
finish
