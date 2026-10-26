grows_by() { git merge-base --is-ancestor "$(saved "$1")" "$2" && [ "$(git rev-list --count "$(saved "$1")..$2")" = "$3" ]; }
has_trailer() { git log -1 --format=%B "$1" | grep -qF "(cherry picked from commit $(saved fix))"; }
F="Escape product names in search results (SEC-112)"

in_repo
expect "no cherry-pick is in progress"                           no_operation
expect "main is unchanged"                                       same_commit main "$(saved main)"
expect "release/1.4 has exactly one new commit"                  grows_by r14 release/1.4 1
expect "…with the fix's subject"                                 msg_is release/1.4 "$F"
expect "…and a '(cherry picked from commit <fix>)' line"         has_trailer release/1.4
expect "release/1.4 escapes product.name"                        rev_file_has release/1.4 src/search.js "escapeHtml\(product\.name\)"
expect "release/1.4 has src/html.js"                             in_commit release/1.4 src/html.js
expect "release/1.3 has exactly one new commit"                  grows_by r13 release/1.3 1
expect "…with the fix's subject"                                 msg_is release/1.3 "$F"
expect "…and a '(cherry picked from commit <fix>)' line"         has_trailer release/1.3
expect "release/1.3 escapes product.title (its own field name)"  rev_file_has release/1.3 src/search.js "escapeHtml\(product\.title\)"
expect "release/1.3 doesn't mention product.name"                sh -c "! git show release/1.3:src/search.js | grep -q 'product\.name'"
expect "release/1.3 imports escapeHtml and has src/html.js"      sh -c "git show release/1.3:src/search.js | grep -q \"require('./html')\" && git cat-file -e release/1.3:src/html.js"
expect "the backports kept each release's VERSION"               sh -c "[ \$(git show release/1.4:VERSION) = 1.4.0 ] && [ \$(git show release/1.3:VERSION) = 1.3.2 ]"
expect "no search suggestions leaked into the releases"          sh -c "! git cat-file -e release/1.4:src/suggest.js && ! git cat-file -e release/1.3:src/suggest.js"
expect "tag v1.4.1 points at release/1.4"                        same_commit v1.4.1 release/1.4
expect "tag v1.3.3 points at release/1.3"                        same_commit v1.3.3 release/1.3
expect "no conflict markers"                                     no_conflict_markers
expect "the working tree is clean"                               clean_tree
finish
