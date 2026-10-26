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
scope_ok() { gh project list --owner "@me" --limit 1 >/dev/null 2>&1; }
expect "gh can read your projects (token has the 'project' scope)" scope_ok
scope_ok || { note "Run: gh auth refresh -s project"; finish; }

NUM=$(gh project list --owner "@me" --limit 100 --format json --jq '.projects[] | select(.title=="Brightcart v1.1") | .number' 2>/dev/null | head -1 || true)
expect "a project titled 'Brightcart v1.1' exists"        nonempty "$NUM"
[ -n "$NUM" ] || { note "gh project create --owner @me --title \"Brightcart v1.1\""; finish; }
note "project #$NUM: $(gh project view "$NUM" --owner "@me" --format json --jq .url 2>/dev/null || true)"

linked() {
  gh api graphql -F owner="$ME" -F name=learngit-lab -f query='
    query($owner:String!,$name:String!){ repository(owner:$owner,name:$name){ projectsV2(first:50){ nodes{ title } } } }' \
    --jq '.data.repository.projectsV2.nodes[].title' 2>/dev/null | grep -qx "Brightcart v1.1"
}
expect "it is linked to $R"                               linked
linked || note "gh project link $NUM --owner @me --repo $R"

ITEMS() { gh project item-list "$NUM" --owner "@me" --limit 200 --format json --jq "$1" 2>/dev/null || true; }
SEL='[.items[] | select(.content.type=="Issue" and ((.content.repository // "") | tostring | test("/learngit-lab$")))]'
CNT=$(ITEMS "$SEL | length")
expect "at least 3 learngit-lab issues are on the board (found ${CNT:-0})" gte "$CNT" 3
has_status() { [ "$(ITEMS "[.items[] | select(.status==\"$1\")] | length")" -ge 1 ] 2>/dev/null; }
expect "at least one item is 'Todo'"                       has_status "Todo"
expect "at least one item is 'In Progress'"                has_status "In Progress"
expect "at least one item is 'Done'"                       has_status "Done"
note "statuses now: $(ITEMS '[.items[] | (.status // "(none)")] | group_by(.) | map("\(.[0])=\(length)") | join(", ")')"

DUE=$(ghq "repos/$R/milestones?state=all&per_page=100" --jq '.[] | select(.title=="v1.1") | .due_on // empty')
expect "milestone v1.1 has a due date"                     nonempty "$DUE"
[ -n "$DUE" ] && note "v1.1 is due $DUE"
finish
