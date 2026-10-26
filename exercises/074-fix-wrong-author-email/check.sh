PERSONAL=night.owl.coder@mail.example
WORK=you@brightcart.example
R=origin/main..feature/wishlist-share
only_work() { [ -z "$(git log --format="$1" $R | grep -vxF "$WORK")" ]; }
subjects_ok() {   # the 5 original subjects, in order, each once (a separate .mailmap commit is allowed)
  [ "$(git log --reverse --format=%s $R | grep -xF -f "$LG_DIR/.lg/subjects")" = "$(cat "$LG_DIR/.lg/subjects")" ] &&
  [ "$(git rev-list --count $R)" -le 6 ]
}
code_same() { git diff --quiet "$(saved original)" feature/wishlist-share -- . ':(exclude).mailmap'; }
mapped() { git check-mailmap "Someone <$PERSONAL>" 2>/dev/null | grep -qF "<$WORK>"; }
no_personal_mapped() { [ -z "$(git log --use-mailmap --format='%aE%n%cE' feature/wishlist-share | grep -xF "$PERSONAL")" ]; }

in_repo
expect "no rebase is in progress"                                      no_operation
expect "you're on feature/wishlist-share"                              on_branch feature/wishlist-share
expect "this repo's user.email is $WORK"                               test "$(git config --local user.email)" = "$WORK"
expect "origin/main is unchanged"                                      same_commit origin/main "$(saved base)"
expect "the branch sits directly on origin/main"                       is_ancestor origin/main feature/wishlist-share
expect "the 5 commits keep their messages and order"                   subjects_ok
expect "every author email on the branch is $WORK (raw, no mailmap)"   only_work %ae
expect "every committer email on the branch is $WORK"                  only_work %ce
expect "the code is exactly as before"                                 code_same
expect ".mailmap is committed on the branch"                           in_commit feature/wishlist-share .mailmap
expect ".mailmap maps $PERSONAL to $WORK"                              mapped
expect "with the mailmap, the personal email never shows in the log"   no_personal_mapped
expect "the working tree is clean"                                     clean_tree
finish
