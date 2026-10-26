attr()        { git check-attr "$1" -- "$2" | sed 's/.*: //'; }
no_crlf_in_index() { ! git ls-files --eol | grep -qE '^i/(crlf|mixed)'; }
has_cr()      { LC_ALL=C grep -q "$(printf '\r')" "$1"; }
archive_ok()  {
  _l=$(git archive HEAD | tar -tf - 2>/dev/null) || return 1
  printf '%s\n' "$_l" | grep -q '^src/cart.js$' &&
    ! printf '%s\n' "$_l" | grep -qE '^(tests|\.github)(/|$)|^\.gitattributes$'
}
only_eol_changes() { git diff --ignore-cr-at-eol --quiet "$(saved before)" HEAD -- . ':(exclude).gitattributes'; }

in_repo
expect "you're on main"                                                 sh -c '[ "$(git symbolic-ref -q --short HEAD)" = main ]'
expect ".gitattributes is committed"                                   in_commit HEAD .gitattributes
expect "existing history is untouched (one new commit on top)"         same_commit HEAD~1 "$(saved before)"
expect "no file is stored with CRLF or mixed endings"                  no_crlf_in_index
expect "text files use text=auto"                                       test "$(attr text src/cart.js)" = auto
expect "text files check out with LF (eol=lf)"                          test "$(attr eol src/cart.js)" = lf
expect "*.bat check out with CRLF (eol=crlf)"                           test "$(attr eol scripts/install.bat)" = crlf
expect "*.png is binary (no text conversion, no diff)"                  sh -c "[ \"\$(git check-attr text -- assets/logo.png | sed 's/.*: //')\" = unset ] && [ \"\$(git check-attr diff -- assets/logo.png | sed 's/.*: //')\" = unset ]"
expect "assets/logo.png is byte-for-byte unchanged"                    test "$(git rev-parse HEAD:assets/logo.png)" = "$(git rev-parse "$(saved before):assets/logo.png")"
expect "dist/ files are linguist-generated"                            sh -c "git check-attr linguist-generated -- dist/app.min.js | grep -qE ': (set|true)$'"
expect "dist/ files have no textual diff (-diff)"                      test "$(attr diff dist/app.min.js)" = unset
expect "git archive leaves out tests/, .github/ and .gitattributes"   archive_ok
expect "only line endings changed in existing files"                   only_eol_changes
expect "sh scripts/deploy.sh runs in your working tree"               sh scripts/deploy.sh
expect "scripts/install.bat is CRLF in your working tree"             has_cr scripts/install.bat
expect_not "src/price.js has no CR in your working tree"              has_cr src/price.js
expect "the working tree is clean"                                     clean_tree
finish
