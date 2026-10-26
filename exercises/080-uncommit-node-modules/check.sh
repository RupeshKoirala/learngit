R=main..feature/search
once_each() {
  while IFS= read -r s; do [ "$(git log --format=%s $R | grep -cxF "$s")" = 1 ] || return 1; done < "$LG_DIR/.lg/subjects"
  [ "$(git log --reverse --format=%s $R | grep -xF -f "$LG_DIR/.lg/subjects")" = "$(cat "$LG_DIR/.lg/subjects")" ] &&
  [ "$(git rev-list --count $R)" -le 5 ]
}
ignores() { git show feature/search:.gitignore 2>/dev/null | grep -qE "^/?$1/?\$"; }

in_repo
expect "no rebase is in progress"                                    no_operation
expect "you're on feature/search"                                    on_branch feature/search
expect "main and origin/main haven't moved"                          eval 'same_commit main "$(saved main)" && same_commit origin/main "$(saved main)"'
expect "feature/search is still based on main"                       is_ancestor main feature/search
expect "no commit on any ref contains node_modules/"                 history_lacks_path node_modules
expect "no commit on any ref contains dist/"                         history_lacks_path dist
expect "your 4 commits keep their messages and order, each once"     once_each
expect "code, package.json, package-lock.json and README are unchanged" git diff --quiet "$(saved original)" feature/search -- src package.json package-lock.json README.md
expect ".gitignore on the branch ignores node_modules/"              ignores node_modules
expect ".gitignore on the branch ignores dist/"                      ignores dist
expect "node_modules/ and dist/ are still on disk"                   test -f node_modules/fuzzy-lite/index.js -a -f dist/bundle.js -a -f dist/bundle.js.map
expect "the working tree is clean"                                   clean_tree
finish
