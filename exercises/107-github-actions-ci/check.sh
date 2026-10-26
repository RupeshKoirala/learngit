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
CI=$(raw .github/workflows/ci.yml main || true)
expect "main has .github/workflows/ci.yml"                nonempty "$CI"
yml() { printf '%s\n' "$CI" | grep -qE -- "$1"; }
expect "it triggers on pull_request"                     yml 'pull_request'
expect "it triggers on push"                             yml '(^|[^_])push'
expect "it has a job called 'test'"                      yml '^  test:'
expect "it runs ./test.sh"                               yml '\./test\.sh'

runs() { gh run list --repo "$R" --workflow ci.yml -L 100 --json conclusion,event,headBranch --jq "$1" 2>/dev/null || true; }
expect "a push to main ran CI successfully"              gte "$(runs '[.[] | select(.headBranch=="main" and .event=="push" and .conclusion=="success")] | length')" 1
B=feature/bulk-discount
PR=$(pr_for "$B")
expect "a PR from $B exists"                             nonempty "$PR"
expect "CI went red on $B at least once"                 gte "$(runs "[.[] | select(.headBranch==\"$B\" and .conclusion==\"failure\")] | length")" 1
LATEST=$(runs "[.[] | select(.headBranch==\"$B\")][0].conclusion // empty")
expect "the latest CI run on $B is green"                eq "$LATEST" success
[ "$LATEST" = success ] || note "latest run on $B: ${LATEST:-none yet} - gh run list --branch $B"
REF=$B; [ "$(pr_json "$PR" state .state)" = MERGED ] && REF=main
BULK=$(raw src/bulk.js "$REF" || true)
expect "src/bulk.js no longer has the BUG marker"        eval '[ -n "$BULK" ] && ! printf "%s" "$BULK" | grep -q BUG'

required_test() {
  [ "$(gh api "repos/$R/branches/main/protection/required_status_checks" --jq '[.contexts[]?, .checks[]?.context] | index("test") != null' 2>/dev/null)" = true ] ||
  [ "$(gh api "repos/$R/rules/branches/main" --jq '[.[] | select(.type=="required_status_checks") | .parameters.required_status_checks[].context] | index("test") != null' 2>/dev/null)" = true ]
}
expect "status check 'test' is required on main"         required_test
required_test || note "The context is the job name ('test'), not the workflow name ('CI')."
finish
