annotated() { [ "$(git cat-file -t "refs/tags/$1" 2>/dev/null)" = tag ]; }
CULPRIT=$(saved culprit)
passes() {   # run the SRE repro against the checkout.sh of a revision
  _t="$LG_DIR/.lg/try"; rm -rf "$_t"; mkdir -p "$_t/src"
  git show "$1:src/checkout.sh" > "$_t/src/checkout.sh" 2>/dev/null || return 1
  ( cd "$_t" && sh "$LG_DIR/repro-checkout.sh" ) >/dev/null 2>&1
}
reverted_in() { git log --format=%B "$1" | grep -q "This reverts commit $CULPRIT"; }
inc() { git show main:INCIDENT.md 2>/dev/null; }
inc_has() { inc | grep -qiE -- "$1"; }
mentions_culprit() {
  for _h in $(inc | grep -oE '[0-9a-f]{7,40}'); do
    case "$CULPRIT" in "$_h"*) return 0;; esac
  done; return 1
}
timeline_bullets() {
  [ "$(inc | awk '/^#+ /{ on = (tolower($0) ~ /timeline/); next } on' | grep -cE '^ *[-*] ')" -ge 3 ]
}

in_repo
expect     "no bisect, merge, revert or cherry-pick in progress"        no_operation
expect     "tags v3.0.0 and v3.1.0 were not moved"                      same_commit v3.1.0 "$(saved v310)"
expect     "release/3.1 contains a revert of the culprit commit"         reverted_in "v3.1.0..release/3.1"
expect     "v3.1.1 exists and is an annotated tag"                      annotated v3.1.1
expect     "v3.1.1 is on release/3.1 and builds on v3.1.0"               sh -c 'git merge-base --is-ancestor v3.1.0 v3.1.1 && git merge-base --is-ancestor v3.1.1 release/3.1'
expect     "v3.1.1 passes the checkout repro"                           passes v3.1.1
expect     "v3.1.1 is the revert (not some other fix)"                  reverted_in "v3.1.0..v3.1.1"
expect_not "v3.1.1 contains no 3.2 work"                                is_ancestor "$(saved loyalty)" v3.1.1
expect     "main passes the checkout repro"                             passes main
expect     "main keeps the 3.2 work"                                    sh -c 'git cat-file -e main:src/loyalty.sh && git show main:src/checkout.sh | grep -q gift_message'
expect     "INCIDENT.md is committed on main"                           in_commit main INCIDENT.md
expect     "INCIDENT.md has a Timeline heading"                         inc_has '^#+ .*timeline'
expect     "INCIDENT.md has a Root cause heading"                       inc_has '^#+ .*root cause'
expect     "INCIDENT.md has a Resolution heading"                       inc_has '^#+ .*resolution'
expect     "the timeline has at least 3 bullet points"                  timeline_bullets
expect     "INCIDENT.md names the culprit commit's hash"                mentions_culprit
expect     "INCIDENT.md mentions v3.0.0, v3.1.0 and v3.1.1"             sh -c 'git show main:INCIDENT.md | grep -q "v3\.0\.0" && git show main:INCIDENT.md | grep -q "v3\.1\.0" && git show main:INCIDENT.md | grep -q "v3\.1\.1"'
expect     "the working tree is clean"                                  clean_tree
finish
