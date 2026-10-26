# shellcheck shell=bash
# Helpers for exercise check.sh scripts. Sourced by `lg check`. bash 3.2 compatible.
# Contract: check.sh runs with the current directory = the exercise sandbox ($LG_DIR).
# Use `expect "description" <command...>` for each requirement, then end the script with `finish`.

LG_FAILED=0
if [ -t 1 ]; then _G=$'\033[32m'; _R=$'\033[31m'; _D=$'\033[2m'; _B=$'\033[1m'; _X=$'\033[0m'; else _G= _R= _D= _B= _X=; fi

pass() { printf '  %s✔%s %s\n' "$_G" "$_X" "$*"; }
nope() { printf '  %s✘%s %s\n' "$_R" "$_X" "$*"; LG_FAILED=1; }
note() { printf '    %s%s%s\n' "$_D" "$*" "$_X"; }

# expect "what should be true" cmd args...    passes when the command succeeds
expect() { _d="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$_d"; else nope "$_d"; fi; }
# expect_not "what should be true" cmd args... passes when the command fails
expect_not() { _d="$1"; shift; if "$@" >/dev/null 2>&1; then nope "$_d"; else pass "$_d"; fi; }

finish() {
  echo
  if [ "$LG_FAILED" = 0 ]; then printf '%s%s🎉 Solved!%s\n' "$_B" "$_G" "$_X"; exit 0
  else printf '%sNot yet.%s Fix the ✘ items. Stuck? %s./lg hint%s\n' "$_R" "$_X" "$_B" "$_X"; exit 1; fi
}

# ---- predicates (all return 0/1, no output) ------------------------------------------------------------
in_repo()        { cd "$LG_DIR/${1:-repo}"; }                       # change into a sandbox repo
is_repo()        { git -C "${1:-.}" rev-parse --git-dir >/dev/null 2>&1; }
on_branch()      { [ "$(git symbolic-ref --short -q HEAD)" = "$1" ]; }
branch_exists()  { git show-ref --verify -q "refs/heads/$1"; }
tag_exists()     { git show-ref --verify -q "refs/tags/$1"; }
ref_exists()     { git rev-parse -q --verify "$1^{commit}" >/dev/null; }
same_commit()    { [ "$(git rev-parse "$1^{commit}" 2>/dev/null)" = "$(git rev-parse "$2^{commit}" 2>/dev/null)" ]; }
same_tree()      { [ "$(git rev-parse "$1^{tree}" 2>/dev/null)" = "$(git rev-parse "$2^{tree}" 2>/dev/null)" ]; }
is_ancestor()    { git merge-base --is-ancestor "$1" "$2"; }       # is $1 contained in $2's history?
count_is()       { [ "$(git rev-list --count "$1" 2>/dev/null)" = "$2" ]; }   # count_is <range> <n>
merges_in()      { git rev-list --merges --count "$1"; }
no_merges()      { [ "$(git rev-list --merges --count "$1" 2>/dev/null)" = 0 ]; }
is_merge()       { git rev-parse -q --verify "$1^2" >/dev/null; }
clean_tree()     { [ -z "$(git status --porcelain)" ]; }             # nothing staged, modified or untracked
nothing_staged() { git diff --cached --quiet; }
no_operation()   { _g=$(git rev-parse --git-dir); [ ! -d "$_g/rebase-merge" ] && [ ! -d "$_g/rebase-apply" ] && [ ! -f "$_g/MERGE_HEAD" ] && [ ! -f "$_g/CHERRY_PICK_HEAD" ] && [ ! -f "$_g/REVERT_HEAD" ] && [ ! -f "$_g/BISECT_LOG" ]; }
no_conflict_markers() { ! git grep -qE '^(<<<<<<<|>>>>>>>)( |$)' -- "${1:-.}"; }
file_has()       { grep -qE -- "$2" "$1"; }                            # file_has <path> <ERE>
file_lacks()     { [ -f "$1" ] && ! grep -qE -- "$2" "$1"; }
tracked()        { git ls-files --error-unmatch -- "$1" >/dev/null 2>&1; }
in_commit()      { git cat-file -e "$1:$2" 2>/dev/null; }             # in_commit <rev> <path>
rev_file_has()   { git show "$1:$2" 2>/dev/null | grep -qE -- "$3"; } # rev_file_has <rev> <path> <ERE>
msg_of()         { git log -1 --format=%s "$1"; }
msg_is()         { [ "$(msg_of "$1")" = "$2" ]; }
msg_matches()    { msg_of "$1" | grep -qE -- "$2"; }
author_of()      { git log -1 --format='%an <%ae>' "$1"; }
history_has_msg(){ git log --format=%s "${2:-HEAD}" | grep -qE -- "$1"; }    # any commit subject matches
history_lacks_path() { [ -z "$(git log --all --format=%H -- "$1")" ]; }        # path never appears in any commit
upstream_of()    { git rev-parse --abbrev-ref --symbolic-full-name "$1@{upstream}" 2>/dev/null; }
remote_ref()     { git --git-dir="$LG_DIR/remotes/${1}.git" rev-parse -q --verify "refs/heads/$2^{commit}" 2>/dev/null; }
remote_has_branch() { [ -n "$(remote_ref "$1" "$2")" ]; }
answer_is()      { [ -f "$LG_DIR/ANSWER" ] && [ "$(tr -d ' \n\r\t' < "$LG_DIR/ANSWER" | tr 'A-Z' 'a-z')" = "$(printf '%s' "$1" | tr 'A-Z' 'a-z')" ]; }
answer_commit_is() {   # ANSWER file holds a (possibly abbreviated) hash that must resolve to $1
  [ -f "$LG_DIR/ANSWER" ] || return 1
  _a=$(tr -d ' \n\r\t' < "$LG_DIR/ANSWER"); [ -n "$_a" ] || return 1
  [ "$(git rev-parse -q --verify "$_a^{commit}" 2>/dev/null)" = "$(git rev-parse "$1^{commit}")" ]
}
saved()          { cat "$LG_DIR/.lg/$1.commit" 2>/dev/null; }           # hash remembered by setup.sh
tree_is_saved()  { [ "$(git rev-parse "$1^{tree}" 2>/dev/null)" = "$(cat "$LG_DIR/.lg/$2.tree" 2>/dev/null)" ]; }
