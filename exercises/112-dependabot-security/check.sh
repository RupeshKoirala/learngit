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
DB=$(raw .github/dependabot.yml main || raw .github/dependabot.yaml main || true)
expect "main has .github/dependabot.yml"                   nonempty "$DB"
d() { printf '%s\n' "$DB" | grep -qE -- "$1"; }
expect "it is version 2"                                   d '^version:[[:space:]]*2'
expect "it updates npm"                                    d 'package-ecosystem:[[:space:]]*"?npm"?'
expect "it updates github-actions"                         d 'package-ecosystem:[[:space:]]*"?github-actions"?'
expect "it has a weekly schedule"                          d 'interval:[[:space:]]*"?weekly"?'

alerts_on() { gh api "repos/$R/vulnerability-alerts" >/dev/null 2>&1; }
expect "Dependabot alerts are enabled"                     alerts_on
expect "Dependabot security updates are enabled"           eq "$(ghq "repos/$R/automated-security-fixes" --jq .enabled)" true

VIS=$(ghq "repos/$R" --jq .visibility)
SS=$(ghq "repos/$R" --jq '.security_and_analysis.secret_scanning.status // "unavailable"')
PP=$(ghq "repos/$R" --jq '.security_and_analysis.secret_scanning_push_protection.status // "unavailable"')
if [ "$VIS" = public ]; then
  expect "secret scanning is enabled"                      eq "$SS" enabled
  expect "push protection is enabled"                      eq "$PP" enabled
else
  note "repo is $VIS: secret scanning=$SS, push protection=$PP (needs a public repo or a paid security plan - not required)"
fi
N=$(ghq "repos/$R/dependabot/alerts?state=open" --jq length)
note "open Dependabot alerts right now: ${N:-unknown}  (they can take a few minutes after enabling)"
DPR=$(gh pr list --repo "$R" --author app/dependabot --state open --json number --jq length 2>/dev/null || true)
note "open Dependabot PRs: ${DPR:-0}"
finish
