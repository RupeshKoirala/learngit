# ---- module 12 lab helpers: one persistent GitHub lab, next to the exercise sandboxes -------------------
LAB="$(cd "$LG_DIR/.." && pwd)/github-lab"
lab_git() { env -u GIT_CONFIG_GLOBAL -u GIT_CONFIG_NOSYSTEM git "$@"; }   # your real git config = your GitHub credentials
stop() { printf '\n  %s\n\n' "$*"; exit 1; }
{ [ -d "$LAB/.git" ] && git -C "$LAB" remote get-url origin >/dev/null 2>&1; } \
  || stop "Your GitHub lab isn't set up yet - do exercise 100 first:  ./lg start 100"
command -v gh >/dev/null 2>&1 || stop "This exercise needs the GitHub CLI: brew install gh && gh auth login"
gh auth status >/dev/null 2>&1 || stop "gh isn't logged in yet. Run: gh auth login"
ME=$(gh api user -q .login); R="$ME/learngit-lab"
gh api "repos/$R" >/dev/null 2>&1 || stop "github.com/$R doesn't exist yet - finish exercise 100 first:  ./lg start 100"
cd "$LAB"
unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE      # real timestamps: this repo lives on GitHub
export GH_PROMPT_DISABLED=1
_gd=$(git rev-parse --git-dir)
{ [ ! -d "$_gd/rebase-merge" ] && [ ! -d "$_gd/rebase-apply" ] && [ ! -f "$_gd/MERGE_HEAD" ]; } \
  || stop "A rebase/merge is still in progress in $LAB. Finish or abort it first."
[ -z "$(git status --porcelain)" ] || stop "Your lab has uncommitted changes. Commit or stash them first:  cd $LAB && git status"
lab_git fetch -q --prune origin || stop "Couldn't fetch from GitHub. Try: gh auth setup-git"
git switch -q main
git merge -q --ff-only origin/main 2>/dev/null || echo "  (note: your local main has diverged from origin/main - left as it is)"
labcommit() { git add -A; git commit -q -m "$1"; }
seed_branch() { git switch -q -C "$1" origin/main; }           # a fresh scenario branch from GitHub's main
publish() {                                                    # force-push a scenario branch, go back to main
  lab_git push -q -f -u origin "$1" >/dev/null 2>&1 || stop "Couldn't push $1 to GitHub. Try: gh auth setup-git"
  git switch -q main
}
# ---------------------------------------------------------------------------------------------------------
B=review/loyalty-points
seed_branch "$B"; as jo
write src/loyalty.js \
  "// Loyalty points: 1 point per whole dollar spent" \
  "function pointsFor(totalCents) {" \
  "  return totalCents / 100;" \
  "}" \
  "" \
  "module.exports = { pointsFor };"
labcommit "Add loyalty points"
as you
lab_git push -q -f origin "$B" >/dev/null 2>&1 || stop "Couldn't push $B to GitHub. Try: gh auth setup-git"
remember seed "$B"
git switch -q main
git branch -q -D "$B"            # you'll get it back with gh pr checkout
PR=$(gh pr list --repo "$R" --head "$B" --state open --json number --jq '.[0].number // empty')
if [ -z "$PR" ]; then
  url=$(gh pr create --repo "$R" --base main --head "$B" --title "Add loyalty points" \
        --body "Jo's first PR. pointsFor(1999) should be 19 points (whole dollars only).")
  PR=${url##*/}
fi
printf '\n  Jo (new hire) opened PR #%s from %s. You do not have that branch locally.\n' "$PR" "$B"
