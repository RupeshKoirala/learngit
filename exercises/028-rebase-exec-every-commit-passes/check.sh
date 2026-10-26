subjects_are() { [ "$(git log --reverse --format=%s "$1" 2>/dev/null | tr '\n' '|')" = "$2" ]; }
every_commit_passes() {   # every_commit_passes <range>   runs ./test.sh on a snapshot of each commit
  _t=$(mktemp -d "${TMPDIR:-/tmp}/lgx.XXXXXX")
  for _c in $(git rev-list --reverse "$1"); do
    rm -rf "$_t/w"; mkdir "$_t/w"
    git archive "$_c" | tar -x -C "$_t/w"
    ( cd "$_t/w" && sh ./test.sh ) >/dev/null 2>&1 || { rm -rf "$_t"; return 1; }
  done
  rm -rf "$_t"
}

in_repo
F=feature/loyalty
expect "ANSWER holds the hash of the first failing commit"        answer_commit_is "$(saved broken)"
expect "no rebase is in progress"                                 no_operation
expect "main still points at 'Initial storefront'"                msg_is main "Initial storefront"
expect "$F is based on main"                                      is_ancestor main $F
expect "$F has exactly 3 commits on top of main"                  count_is main..$F 3
expect "commits are: tiers, calculator, checkout (in order)"      subjects_are main..$F "Add loyalty tier names|Add loyalty points calculator|Award loyalty points at checkout|"
expect "./test.sh passes on EVERY commit of the branch"           every_commit_passes main..$F
expect "the final files are exactly what you had before"          tree_is_saved $F original
expect "the working tree is clean"                                clean_tree
finish
