LAB="$(cd "$LG_DIR/.." && pwd)/github-lab"
gh_ready() { command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; }
expect "gh is installed and logged in" gh_ready
if ! gh_ready; then note "Run: gh auth login   (then ./lg check again)"; finish; fi
ME=$(gh api user -q .login 2>/dev/null || true); R="$ME/learngit-lab"
note "logged in as $ME"

expect "the local lab exists at $LAB" test -d "$LAB/.git"
[ -d "$LAB/.git" ] || { note "Run ./lg start 100 to (re)create it."; finish; }
cd "$LAB"

repo_exists() { gh api "repos/$R" >/dev/null 2>&1; }
expect "github.com/$R exists" repo_exists
if ! repo_exists; then
  note "From inside the lab: gh repo create learngit-lab --private --source=. --remote=origin --push"
  finish
fi
field() { gh api "repos/$R" --jq "$1" 2>/dev/null || true; }
expect "the repo is private"                      eq "$(field .private)" true
[ "$(field .private)" = true ] || note "Exercise 106/112 may later ask you to make it public on a Free plan - that's fine then."
expect "its default branch is main"               eq "$(field .default_branch)" main

origin_ok() { git remote get-url origin 2>/dev/null | grep -qiE "github\.com[:/]$ME/learngit-lab(\.git)?$"; }
expect "origin points at $R"                      origin_ok
origin_ok || note "origin is: $(git remote get-url origin 2>/dev/null || echo '(none)')"
REMOTE_MAIN=$(gh api "repos/$R/commits/main" --jq .sha 2>/dev/null || true)
expect "GitHub's main has exactly your local main" eq "$(git rev-parse main 2>/dev/null)" "$REMOTE_MAIN"
expect "local main tracks origin/main"            eq "$(upstream_of main)" origin/main
[ "$(upstream_of main)" = origin/main ] || note "Fix with: git branch -u origin/main main"

desc_ok() { field .description | grep -qi brightcart; }
expect "the description mentions Brightcart"     desc_ok
has_topic() { field '.topics[]' | grep -qx "$1"; }
expect "the repo has the topic 'git'"             has_topic git
expect "the repo has the topic 'brightcart'"      has_topic brightcart
note "Scopes matter later: 107 needs 'workflow', 114 needs 'project' (gh auth refresh -s project)."
finish
