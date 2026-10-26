gh_ready() { command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; }
if ! gh_ready; then nope "gh is installed and logged in"; note "Run: gh auth login"; finish; fi
ME=$(gh api user -q .login 2>/dev/null || true); F="$ME/Spoon-Knife"; U=octocat/Spoon-Knife

expect "your fork $F exists and is a fork of $U" eq "$(gh api "repos/$F" --jq '.fork and .parent.full_name=="octocat/Spoon-Knife"' 2>/dev/null)" true
CLONE="$LG_DIR/Spoon-Knife"
expect "it is cloned into this sandbox (./Spoon-Knife)"      is_repo "$CLONE"
url_is() { git -C "$CLONE" remote get-url "$1" 2>/dev/null | grep -qiE "github\.com[:/]$2(\.git)?$"; }
expect "origin is your fork"                                  url_is origin "$F"
expect "upstream is octocat/Spoon-Knife"                      url_is upstream "$U"

UPSHA=$(gh api "repos/$U/commits/main" --jq .sha 2>/dev/null || true)
SYNC=$(gh api "repos/$F/compare/$UPSHA...main" --jq .status 2>/dev/null || true)
expect "your fork's main contains upstream's latest main (synced)" eval 'case "$SYNC" in identical|ahead) true;; *) false;; esac'
[ "$SYNC" = behind ] && note "gh repo sync $F"
local_synced() { [ -n "$UPSHA" ] && git -C "$CLONE" merge-base --is-ancestor "$UPSHA" main 2>/dev/null; }
expect "your local main has it too (pulled)"                  local_synced

PRS=$(gh pr list --repo "$F" --state all --json number,headRefName,baseRefName --jq '[.[] | select(.baseRefName=="main" and .headRefName!="main")] | length' 2>/dev/null || true)
expect "a PR from a branch into YOUR fork's main exists"      gte "$PRS" 1
UPOPEN=$(gh pr list --repo "$U" --author "$ME" --state open --json number --jq '[.[].number | tostring] | join(" ")' 2>/dev/null || true)
expect "you have no open PRs to octocat/Spoon-Knife"          eq "$UPOPEN" ""
[ -z "$UPOPEN" ] || note "close them: gh pr close <N> --repo $U   (open: $UPOPEN)"
finish
