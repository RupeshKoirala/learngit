tests_pass() {   # export a revision's tree and run its test suite plus the combined currency+refund cases
  _t="$LG_DIR/.lg/tree"; rm -rf "$_t"; mkdir -p "$_t"
  git archive "$1" | tar -x -C "$_t" || return 1
  ( cd "$_t" && sh ./test.sh ) >/dev/null 2>&1
}
formats_both() {
  _t="$LG_DIR/.lg/fmt"; rm -rf "$_t"; mkdir -p "$_t"
  git show "$1:lib/money.sh" > "$_t/money.sh" 2>/dev/null || return 1
  ( cd "$_t" && . ./money.sh && [ "$(format_price -250 GBP)" = '-GBP 2.50' ] && [ "$(format_price -150)" = '-$1.50' ] \
      && [ "$(format_price 1999 EUR)" = 'EUR 19.99' ] && [ "$(format_price 5)" = '$0.05' ] ) >/dev/null 2>&1
}
no_src() { [ -z "$(git ls-tree -r --name-only "$1" -- src)" ]; }
first_parent_has() { git rev-list --first-parent "$1" | grep -qx "$2"; }
remote_is() { [ "$(remote_ref origin "$1")" = "$(git rev-parse "$1" 2>/dev/null)" ]; }
OLDF=$(saved oldfeature); OLDM=$(saved oldmain)

in_repo
expect     "ANSWER says merge (the branch is shared — don't rewrite it)" answer_is merge
expect     "no merge, rebase or cherry-pick is in progress"            no_operation
expect     "no conflict markers left"                                  no_conflict_markers
expect     "feature/multi-currency kept its original commits (not rewritten)" is_ancestor "$OLDF" feature/multi-currency
expect     "feature/multi-currency contains main"                      is_ancestor "$OLDM" feature/multi-currency
expect     "feature/multi-currency: ./test.sh passes"                  tests_pass feature/multi-currency
expect     "main contains the feature"                                 is_ancestor feature/multi-currency main
expect     "main's first-parent history still runs through the old main tip" first_parent_has main "$OLDM"
expect     "main: no src/ folder left"                                 no_src main
expect     "main: lib/currency.sh exists"                              in_commit main lib/currency.sh
expect     "main: format_price does currencies AND refunds (-GBP 2.50)" formats_both main
expect     "main: ./test.sh passes"                                    tests_pass main
expect     "main: README keeps the Multi-currency and Search sections" sh -c 'git show main:README.md | grep -q "^## Multi-currency" && git show main:README.md | grep -q "^## Search"'
expect     "origin/main is pushed"                                     remote_is main
expect     "origin/feature/multi-currency is pushed"                   remote_is feature/multi-currency
expect     "the working tree is clean"                                 clean_tree
finish
