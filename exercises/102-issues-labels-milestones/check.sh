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
has_label() { gh label list --repo "$R" --limit 200 --json name --jq '.[].name' 2>/dev/null | grep -qx "$1"; }
expect "label 'priority:high' exists"           has_label "priority:high"
expect "label 'area:checkout' exists"           has_label "area:checkout"
MS=$(ghq "repos/$R/milestones?state=all&per_page=100" --jq '.[] | select(.title=="v1.1") | .number')
expect "milestone 'v1.1' exists"                nonempty "$MS"
[ -n "$MS" ] || note "gh api repos/{owner}/{repo}/milestones -f title=v1.1"

ISS() { gh issue list --repo "$R" --milestone v1.1 --state all --limit 200 --json number,labels,assignees,state --jq "$1" 2>/dev/null || true; }
COUNT=$(ISS 'length'); [ -n "$COUNT" ] || COUNT=0
expect "at least 3 issues are in milestone v1.1 (found $COUNT)"      gte "$COUNT" 3
expect "every v1.1 issue has at least one label"                     eq "$(ISS 'all(.[]; (.labels|length) > 0)')" true
expect "every v1.1 issue is assigned to you ($ME)"                   eq "$(ISS "all(.[]; any(.assignees[]; .login==\"$ME\"))")" true
expect "at least one v1.1 issue is labelled priority:high"           gte "$(ISS '[.[] | select(any(.labels[]; .name=="priority:high"))] | length')" 1
unlabelled=$(ISS '[.[] | select((.labels|length)==0) | "#\(.number)"] | join(" ")')
[ -z "$unlabelled" ] || note "no label yet: $unlabelled   (gh issue edit N --add-label ...)"
unassigned=$(ISS "[.[] | select(all(.assignees[]; .login!=\"$ME\")) | \"#\(.number)\"] | join(\" \")")
[ -z "$unassigned" ] || note "not assigned to you: $unassigned   (gh issue edit N --add-assignee @me)"

# a closed v1.1 issue whose number appears after a closing keyword in a merged PR
MERGED=$(gh pr list --repo "$R" --state merged --limit 200 --json number,title,body --jq '.[] | "\(.number)\t\(.title) \(.body)"' 2>/dev/null | tr '\n' ' ' || true)
auto_closed() {
  for n in $(ISS '.[] | select(.state=="CLOSED") | .number'); do
    if printf '%s' "$MERGED" | grep -qiE "(close[sd]?|fix(e[sd])?|resolve[sd]?):? #$n([^0-9]|$)"; then FIXED=$n; return 0; fi
  done
  return 1
}
FIXED=""
expect "a v1.1 issue was closed by a merged PR saying 'Fixes #N'" auto_closed
if [ -n "$FIXED" ]; then note "issue #$FIXED was closed by a merged PR"
else note "Write 'Fixes #N' in the PR body and merge it into main; the issue closes on merge."; fi
finish
