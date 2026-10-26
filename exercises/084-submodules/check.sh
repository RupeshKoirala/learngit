UI="$LG_DIR/remotes/ui-kit.git"; SF="$LG_DIR/remotes/storefront.git"
v10=$(git --git-dir="$UI" rev-parse -q --verify 'v1.0.0^{commit}' 2>/dev/null)
v11=$(git --git-dir="$UI" rev-parse -q --verify 'v1.1.0^{commit}' 2>/dev/null)
gitlink_at() { git --git-dir="$SF" ls-tree "$1" libs/ui-kit 2>/dev/null | awk '$1=="160000"{print $3}'; }
ever_pinned_to() { for c in $(git --git-dir="$SF" rev-list main 2>/dev/null); do [ "$(gitlink_at "$c")" = "$1" ] && return 0; done; return 1; }
gitmodules_ok() {
  git --git-dir="$SF" show main:.gitmodules > "$LG_DIR/.lg/gm" 2>/dev/null || return 1
  [ "$(git config -f "$LG_DIR/.lg/gm" submodule.libs/ui-kit.path)" = "libs/ui-kit" ] &&
    git config -f "$LG_DIR/.lg/gm" submodule.libs/ui-kit.url | grep -q 'ui-kit\.git$'
}
sub_head() { git -C "$1/libs/ui-kit" rev-parse -q --verify HEAD 2>/dev/null; }
answer_ok() {
  [ -f "$LG_DIR/ANSWER" ] || return 1
  _a=$(tr -d ' \n\r\t' < "$LG_DIR/ANSWER"); [ ${#_a} -ge 4 ] || return 1
  [ "$(git --git-dir="$UI" rev-parse -q --verify "$_a^{commit}" 2>/dev/null)" = "$v11" ]
}

mkdir -p "$LG_DIR/.lg"
expect "Lena released ui-kit v1.1.0 (run ./lg event after your first push)"   test -n "$v11"
expect "origin's .gitmodules declares libs/ui-kit -> …/ui-kit.git"           gitmodules_ok
expect "origin's history pinned libs/ui-kit to v1.0.0 first"                  ever_pinned_to "$v10"
expect "origin's main now pins libs/ui-kit to exactly v1.1.0"                 test -n "$v11" -a "$(gitlink_at main)" = "$v11"
in_repo
expect "your main is pushed (same as origin/main)"                            same_commit main "$(git --git-dir="$SF" rev-parse main)"
expect "repo/libs/ui-kit is checked out at v1.1.0"                            test -n "$v11" -a "$(sub_head "$LG_DIR/repo")" = "$v11"
expect "repo is clean (no modified or untracked submodule state)"             clean_tree
cd "$LG_DIR"
expect "fresh/ is a clone of the storefront"                                  test -d fresh/.git
expect "fresh/libs/ui-kit is populated at v1.1.0"                             test -n "$v11" -a "$(sub_head "$LG_DIR/fresh")" = "$v11" -a -f fresh/libs/ui-kit/badge.css
expect "ANSWER holds the commit the superproject pins (v1.1.0's hash)"        answer_ok
finish
