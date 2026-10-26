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
HOT=$(gh pr list --repo "$R" --head hotfix/round-totals --state merged --json number --jq '.[0].number // empty' 2>/dev/null || true)
expect "the hotfix PR (hotfix/round-totals) is merged"   nonempty "$HOT"
PR=$(pr_for feature/sale-banner)
expect "a PR from feature/sale-banner exists"            nonempty "$PR"
[ -n "$PR" ] || { note "gh pr create --head feature/sale-banner --base main --fill"; finish; }
STATE=$(pr_json "$PR" state .state); MERGEABLE=$(pr_json "$PR" mergeable .mergeable)
note "PR #$PR is $STATE (mergeable: ${MERGEABLE:-?})"
REF=feature/sale-banner; [ "$STATE" = MERGED ] && REF=main
LOG=$(raw CHANGELOG.md "$REF" || true)
has() { printf '%s\n' "$LOG" | grep -qF -- "$1"; }
expect "CHANGELOG.md on $REF keeps Dev's line"                has "- Fix: totals are rounded to whole cents"
expect "CHANGELOG.md on $REF keeps your line"                 has "- New: sale banner on the home page"
expect "CHANGELOG.md on $REF has no conflict markers"         eval '[ -n "$LOG" ] && ! printf "%s\n" "$LOG" | grep -qE "^(<<<<<<<|=======|>>>>>>>)"'
contains_hotfix() { [ "$STATE" = MERGED ] || [ "$MERGEABLE" = MERGEABLE ]; }
expect "your PR is no longer conflicting with main"           contains_hotfix
[ "$MERGEABLE" = UNKNOWN ] && note "GitHub is still computing mergeability - run ./lg check again in a few seconds."
expect "your PR is merged"                                    eq "$STATE" MERGED
expect "no rebase or merge is left half-done in the lab"      no_operation
finish
