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
pr_merged() { gh pr list --repo "$R" --head "$1" --state merged --json number --jq '.[0].number // empty' 2>/dev/null || true; }
mc_of() { pr_json "$1" mergeCommit '.mergeCommit.oid'; }
PM=$(pr_merged demo/merge-commit); PS=$(pr_merged demo/squash); PR_=$(pr_merged demo/rebase)
expect "demo/merge-commit was merged through a PR"  nonempty "$PM"
expect "demo/squash was merged through a PR"        nonempty "$PS"
expect "demo/rebase was merged through a PR"        nonempty "$PR_"

REMOTE_MAIN=$(ghq "repos/$R/commits/main" --jq .sha)
expect "your local main equals GitHub's main (you pulled)" eq "$(git rev-parse main 2>/dev/null)" "$REMOTE_MAIN"
[ "$(git rev-parse main 2>/dev/null)" = "$REMOTE_MAIN" ] || note "git switch main && git pull"

parents() { git rev-list --parents -n 1 "$1" 2>/dev/null | awk '{print NF-1}'; }
known() { [ -n "$1" ] && git cat-file -e "$1^{commit}" 2>/dev/null; }
by_merge() { c=$(mc_of "$PM"); known "$c" && [ "$(parents "$c")" = 2 ]; }
by_squash() {
  c=$(mc_of "$PS"); known "$c" && [ "$(parents "$c")" = 1 ] && [ "$(git log -1 --format=%s "$c^")" != "Add product reviews" ] \
    && git show --stat --format= "$c" | grep -q src/reviews.js
}
by_rebase() {
  c=$(mc_of "$PR_"); known "$c" && [ "$(parents "$c")" = 1 ] \
    && [ "$(git log -1 --format=%s "$c")" = "Search is case-insensitive" ] && [ "$(git log -1 --format=%s "$c^")" = "Add product search" ]
}
expect "demo/merge-commit landed as a merge commit (2 parents)"            by_merge
expect "demo/squash landed as ONE squashed commit (\"fix typo\" is gone)"  by_squash
expect "demo/rebase landed as 2 replayed commits, no merge commit"         by_rebase
if [ -n "$PM$PS$PR_" ]; then
  note "squash commit:  $(git log -1 --format='%h %s' "$(mc_of "$PS")" 2>/dev/null || echo '?')"
  note "merge commit:   $(git log -1 --format='%h %s' "$(mc_of "$PM")" 2>/dev/null || echo '?')"
fi

setting() { ghq "repos/$R" --jq "$1"; }
expect "merge commits are disabled for the repo"        eq "$(setting .allow_merge_commit)" false
expect "squash merging is enabled"                      eq "$(setting .allow_squash_merge)" true
expect "head branches are deleted automatically"        eq "$(setting .delete_branch_on_merge)" true
note "rebase merging is $( [ "$(setting .allow_rebase_merge)" = true ] && echo enabled || echo disabled ) - your call."
finish
