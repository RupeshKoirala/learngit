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
TPL=$(raw .github/pull_request_template.md || raw .github/PULL_REQUEST_TEMPLATE.md || raw pull_request_template.md || true)
expect "main has a PR template (.github/pull_request_template.md)" nonempty "$TPL"
tpl() { printf '%s\n' "$TPL" | grep -qiE -- "$1"; }
expect "the PR template has What / Why / How to test"    eval 'tpl "what" && tpl "why" && tpl "how to test"'
expect "the PR template has a checklist (- [ ] ...)"     tpl '^[[:space:]]*[-*] \[ \]'

BUGF=$(raw .github/ISSUE_TEMPLATE/bug_report.yml || raw .github/ISSUE_TEMPLATE/bug_report.yaml || true)
FEAT=$(raw .github/ISSUE_TEMPLATE/feature_request.yml || raw .github/ISSUE_TEMPLATE/feature_request.yaml || true)
y() { printf '%s\n' "$1" | grep -qE -- "$2"; }
expect "bug_report.yml exists on main"                   nonempty "$BUGF"
expect "bug_report.yml has name, description and body"  eval 'y "$BUGF" "^name:" && y "$BUGF" "^description:" && y "$BUGF" "^body:"'
expect "bug_report.yml labels issues 'bug'"              y "$BUGF" '^labels:.*bug|^  - "?bug"?$'
expect "bug_report.yml has a textarea field"             y "$BUGF" 'type:[[:space:]]*textarea'
expect "feature_request.yml exists on main"              nonempty "$FEAT"
expect "feature_request.yml has name, description and body" eval 'y "$FEAT" "^name:" && y "$FEAT" "^description:" && y "$FEAT" "^body:"'
expect "feature_request.yml labels issues 'enhancement'" y "$FEAT" 'enhancement'

CO=""; for p in .github/CODEOWNERS CODEOWNERS docs/CODEOWNERS; do CO=$(raw "$p" || true); [ -n "$CO" ] && { COP=$p; break; }; done
expect "a CODEOWNERS file exists on main"                nonempty "$CO"
[ -n "$CO" ] && note "found $COP"
owns() { printf '%s\n' "$CO" | grep -iE "^$1[[:space:]]" | grep -qiE "@$ME([[:space:]]|$)"; }
expect "CODEOWNERS: you own everything (*)"              owns '\*'
expect "CODEOWNERS: you own /src/"                       owns '/?src/?\*{0,2}'
ERRS=$(ghq "repos/$R/codeowners/errors" --jq '.errors | length')
expect "GitHub reports no CODEOWNERS errors"             eq "$ERRS" 0
[ "$ERRS" = 0 ] || [ -z "$ERRS" ] || note "$(ghq "repos/$R/codeowners/errors" --jq '.errors[] | "line \(.line): \(.message)"' | head -3)"
finish
