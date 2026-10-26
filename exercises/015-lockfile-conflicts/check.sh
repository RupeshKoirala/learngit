# Is the committed lockfile exactly what tools/lock.sh generates from the committed package.json?
lock_is_fresh() {
  _t=$(mktemp -d "${TMPDIR:-/tmp}/lglock.XXXXXX") || return 1
  git archive feature/review-markdown | tar -x -C "$_t" || { rm -rf "$_t"; return 1; }
  cp "$_t/package-lock.json" "$_t/committed.lock" 2>/dev/null || { rm -rf "$_t"; return 1; }
  ( cd "$_t" && sh tools/lock.sh >/dev/null 2>&1 ) || { rm -rf "$_t"; return 1; }
  cmp -s "$_t/package-lock.json" "$_t/committed.lock"; _r=$?
  rm -rf "$_t"; return $_r
}
return_line() { git show feature/review-markdown:src/product-page.js 2>/dev/null | grep 'return '; }

in_repo
expect "no merge is in progress"                                 no_operation
expect "you're on feature/review-markdown"                       on_branch feature/review-markdown
expect "main is unchanged"                                       same_commit main "$(saved main)"
expect "your branch ends with a merge of main"                   test "$(git rev-parse feature/review-markdown^1 feature/review-markdown^2 2>/dev/null)" = "$(printf '%s\n' "$(saved feature)" "$(saved main)")"
expect "no conflict markers are left"                            no_conflict_markers
expect "package.json lists dayjs and marked"                     eval "rev_file_has HEAD package.json '\"dayjs\"' && rev_file_has HEAD package.json '\"marked\"'"
expect "package-lock.json has both packages"                     eval "rev_file_has HEAD package-lock.json 'node_modules/dayjs' && rev_file_has HEAD package-lock.json 'node_modules/marked'"
expect "package-lock.json is freshly generated (matches ./tools/lock.sh output)" lock_is_fresh
expect "product-page.js requires dayjs"                          rev_file_has HEAD src/product-page.js "require\('dayjs'\)"
expect "product-page.js requires marked"                         rev_file_has HEAD src/product-page.js "require\('marked'\)"
expect "there is exactly one return line in renderReview"        test "$(return_line | grep -c .)" = 1
expect "the review text is rendered as Markdown"                 eval "return_line | grep -q 'marked\.parseInline(review\.text)'"
expect "...followed by the formatted date"                       eval "return_line | grep -q 'marked\.parseInline(review\.text).*dayjs(review\.date)\.format('"
expect "the working tree is clean"                               clean_tree
finish
