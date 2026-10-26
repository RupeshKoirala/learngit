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
B1=stack/1-tax-calc; B2=stack/2-tax-display
P1=$(pr_for "$B1"); P2=$(pr_for "$B2")
expect "a PR from $B1 exists"                         nonempty "$P1"
expect "a PR from $B2 exists"                         nonempty "$P2"
[ -n "$P1" ] && [ -n "$P2" ] || finish

timeline() {   # timeline <pr> <jq>
  gh api graphql -F owner="$ME" -F name=learngit-lab -F n="$1" -f query='
    query($owner:String!,$name:String!,$n:Int!){ repository(owner:$owner,name:$name){ pullRequest(number:$n){
      timelineItems(first:100, itemTypes:[READY_FOR_REVIEW_EVENT, BASE_REF_CHANGED_EVENT, CONVERT_TO_DRAFT_EVENT]){
        nodes{ __typename ... on BaseRefChangedEvent { previousRefName currentRefName } } } } } }' \
    --jq "$2" 2>/dev/null || true
}
expect "PR #$P1 started as a draft and was marked ready"   gte "$(timeline "$P1" '[.data.repository.pullRequest.timelineItems.nodes[] | select(.__typename=="ReadyForReviewEvent")] | length')" 1
expect "PR #$P1 is merged"                                 eq "$(pr_json "$P1" state .state)" MERGED
expect "PR #$P2 was stacked on $B1 (its base was changed from it)" \
  gte "$(timeline "$P2" "[.data.repository.pullRequest.timelineItems.nodes[] | select(.__typename==\"BaseRefChangedEvent\" and .previousRefName==\"$B1\")] | length")" 1
expect "PR #$P2 now targets main"                          eq "$(pr_json "$P2" baseRefName .baseRefName)" main

C1=$(pr_json "$P1" commits '.commits[].oid')
C2=$(pr_json "$P2" commits '.commits[].oid')
dup=""; for c in $C1; do case " $(echo $C2) " in *" $c "*) dup=$c;; esac; done
expect "PR #$P2 no longer contains PR #$P1's original commit(s)" eq "$dup" ""
[ -z "$dup" ] || note "rebase it: git rebase --onto origin/main <old $B1 tip> $B2 && git push --force-with-lease"
S2=$(pr_json "$P2" state .state); M2=$(pr_json "$P2" mergeable .mergeable)
expect "PR #$P2 is mergeable (or merged)"                  eval '[ "$S2" = MERGED ] || [ "$M2" = MERGEABLE ]'
[ "$M2" = UNKNOWN ] && note "GitHub is still computing mergeability - try again in a few seconds."
finish
