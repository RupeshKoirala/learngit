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
T="Show thousands separators in prices"
B=feature/price-separators
ISSUE=$(gh issue list --repo "$R" --state all --limit 200 --json number,title \
          --jq ".[] | select(.title==\"$T\") | .number" 2>/dev/null | head -1 || true)
expect "the issue \"$T\" exists"                     nonempty "$ISSUE"
expect "local branch $B exists"                     branch_exists "$B"
expect "$B tracks origin/$B (pushed with -u)"       eq "$(upstream_of "$B")" "origin/$B"
PR=$(pr_for "$B")
expect "a pull request from $B exists"              nonempty "$PR"
if [ -z "$PR" ]; then note "Push the branch, then: gh pr create --base main"; finish; fi
note "PR #$PR: $(pr_json "$PR" url .url)"
expect "it targets main"                            eq "$(pr_json "$PR" baseRefName .baseRefName)" main
expect "it is not a draft"                          eq "$(pr_json "$PR" isDraft .isDraft)" false
TITLE=$(pr_json "$PR" title .title)
good_title() { [ "${#TITLE}" -ge 12 ] && [ "$TITLE" != "$B" ] && ! printf '%s' "$TITLE" | grep -qi '^feature/'; }
expect "the title describes the change (not the branch name)" good_title
BODY=$(pr_json "$PR" body .body)
section() { printf '%s\n' "$BODY" | grep -qiE "^[#* ]*$1"; }
expect "the body has a 'What' section"              section 'what'
expect "the body has a 'Why' section"               section 'why'
expect "the body has a 'How to test' section"       section 'how to test'
closes() { [ -n "$ISSUE" ] && printf '%s\n' "$BODY" | grep -qiE "(close[sd]?|fix(e[sd])?|resolve[sd]?):? #$ISSUE([^0-9]|$)"; }
expect "the body closes issue #$ISSUE (e.g. 'Closes #$ISSUE')" closes
touches() { pr_json "$PR" files '.files[].path' | grep -qx src/price.js; }
expect "the PR changes src/price.js"                touches
if [ "$LG_FAILED" = 0 ]; then
  note "Nice. Merge it with: gh pr merge $PR --squash --delete-branch  - then watch #$ISSUE close itself."
fi
finish
