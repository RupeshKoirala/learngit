# This exercise doesn't use the lab: you fork octocat/Spoon-Knife (GitHub's official practice repo)
# and clone it into this exercise's sandbox. Nothing here ever opens a PR to someone else's repo.
stop() { printf '\n  %s\n\n' "$*"; exit 1; }
command -v gh >/dev/null 2>&1 || stop "This exercise needs the GitHub CLI: brew install gh && gh auth login"
gh auth status >/dev/null 2>&1 || stop "gh isn't logged in yet. Run: gh auth login"
ME=$(gh api user -q .login)
if gh api "repos/$ME/Spoon-Knife" >/dev/null 2>&1; then
  printf '\n  You already have a fork: github.com/%s/Spoon-Knife (gh repo fork will just clone it).\n' "$ME"
fi
printf '\n  Work in: %s\n' "$LG_DIR"
