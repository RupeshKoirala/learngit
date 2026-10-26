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
classic() { gh api "repos/$R/branches/main/protection" --jq "$1" 2>/dev/null || true; }
rules()   { gh api "repos/$R/rules/branches/main" --jq "$1" 2>/dev/null || true; }
nrule()   { n=$(rules "[.[] | select(.type==\"$1\")] | length"); echo "${n:-0}"; }
HAS_CLASSIC=$(classic '.url')
HAS_RULES=$(rules 'length'); HAS_RULES=${HAS_RULES:-0}
if [ -n "$HAS_CLASSIC" ]; then note "found classic branch protection on main"; fi
if [ "$HAS_RULES" -gt 0 ] 2>/dev/null; then note "found $HAS_RULES ruleset rule(s) active on main"; fi
if [ -z "$HAS_CLASSIC" ] && [ "$HAS_RULES" = 0 ]; then
  err=$(gh api "repos/$R/branches/main/protection" 2>&1 || true)
  case "$err" in *Upgrade*|*upgrade*) note "GitHub says: upgrade or make the repo public (see the task).";; esac
fi

requires_pr() { [ "$(classic '.required_pull_request_reviews != null')" = true ] || [ "$(nrule pull_request)" -gt 0 ]; }
linear()      { [ "$(classic '.required_linear_history.enabled')" = true ] || [ "$(nrule required_linear_history)" -gt 0 ]; }
no_force()    { [ "$(classic '.allow_force_pushes.enabled')" = false ] || [ "$(nrule non_fast_forward)" -gt 0 ]; }
no_delete()   { [ "$(classic '.allow_deletions.enabled')" = false ] || [ "$(nrule deletion)" -gt 0 ]; }
approvals()   {
  a=$(classic '.required_pull_request_reviews.required_approving_review_count // empty')
  b=$(rules '[.[] | select(.type=="pull_request") | .parameters.required_approving_review_count] | max // empty')
  echo "${a:-0} ${b:-0}"
}
no_bypass() {
  [ "$(classic '.enforce_admins.enabled')" = true ] && return 0
  ids=$(rules '[.[] | select(.type=="pull_request") | .ruleset_id] | unique | .[]')
  [ -n "$ids" ] || return 1
  for id in $ids; do
    c=$(gh api "repos/$R/rulesets/$id" --jq '.current_user_can_bypass // (if (.bypass_actors|length)==0 then "never" else "always" end)' 2>/dev/null || echo always)
    [ "$c" = always ] && return 1
  done
  return 0
}
expect "main requires a pull request"                 requires_pr
expect "main requires linear history"                 linear
expect "force pushes to main are blocked"             no_force
expect "deleting main is blocked"                     no_delete
expect "the rules apply to admins too (no bypass)"    no_bypass
set -- $(approvals)
solo_ok() { requires_pr && [ "$1" -eq 0 ] && [ "$2" -eq 0 ]; }
expect "required approvals = 0 (you can't approve your own PRs)" solo_ok "$1" "$2"
requires_pr && ! solo_ok "$1" "$2" && note "With $1/$2 required approvals and no second account, you could never merge again."

status_test() {
  [ "$(gh api "repos/$R/branches/main/protection/required_status_checks" --jq '[.contexts[]?, .checks[]?.context] | index("test") != null' 2>/dev/null)" = true ] ||
  [ "$(rules '[.[] | select(.type=="required_status_checks") | .parameters.required_status_checks[].context] | index("test") != null')" = true ]
}
if status_test; then note "bonus: status check 'test' is already required (now do 107 so PRs can pass it)"
else note "optional now / required in 107: status check 'test'"; fi

proof() { [ -f "$LG_DIR/ANSWER" ] && grep -qE 'GH006|GH013|[Pp]rotected branch|rule violation' "$LG_DIR/ANSWER"; }
expect "ANSWER holds GitHub's rejection line (GH006 / GH013)" proof
proof || note "File: $LG_DIR/ANSWER"
REMOTE_MAIN=$(ghq "repos/$R/commits/main" --jq .sha)
expect "your local main matches origin/main again (test commit undone)" eq "$(git rev-parse main 2>/dev/null)" "$REMOTE_MAIN"
finish
