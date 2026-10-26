pkg_json() {   # pkg_json <dependency line>...
  write package.json "{" '  "name": "brightcart",' '  "version": "1.5.0",' '  "private": true,' '  "dependencies": {'
  _last=$#; _i=0
  for _d in "$@"; do _i=$((_i + 1)); if [ "$_i" = "$_last" ]; then append package.json "    $_d"; else append package.json "    $_d,"; fi; done
  append package.json "  }" "}"
}
page_js() {    # page_js <require line or ''> <return expression>
  if [ -n "$1" ]; then
    write src/product-page.js "// Product page" "$1" "" "function renderReview(review) {" "  return $2;" "}" "" "module.exports = { renderReview };"
  else
    write src/product-page.js "// Product page" "function renderReview(review) {" "  return $2;" "}" "" "module.exports = { renderReview };"
  fi
}

new_repo repo
brightcart_skeleton
# tools/lock.sh — our stand-in for `npm install`: regenerates package-lock.json from package.json
write tools/lock.sh \
  '#!/bin/sh' \
  '# Stand-in for `npm install`: regenerates package-lock.json from package.json.' \
  '# Never edit package-lock.json by hand. Run ./tools/lock.sh instead.' \
  'set -e' \
  'cd "$(dirname "$0")/.."' \
  'deps=$(awk -F'"'"'"'"'"' '"'"'/"dependencies"/ {d=1; next} d && /}/ {d=0} d && NF >= 4 {print $2, $4}'"'"' package.json | sed '"'"'s/ [~^]/ /'"'"' | LC_ALL=C sort)' \
  'n=$(printf "%s\n" "$deps" | grep -c .)' \
  'hash=$(printf "%s\n" "$deps" | cksum | cut -d" " -f1)' \
  '{' \
  '  echo "{"' \
  '  echo "  \"name\": \"brightcart\","' \
  '  echo "  \"lockfileVersion\": 3,"' \
  '  echo "  \"dependenciesHash\": \"sha1-$hash\","' \
  '  echo "  \"packages\": {"' \
  '  i=0' \
  '  printf "%s\n" "$deps" | while read -r name ver; do' \
  '    i=$((i + 1)); sep=","; [ "$i" = "$n" ] && sep=""' \
  '    sum=$(printf "%s@%s" "$name" "$ver" | cksum | cut -d" " -f1)' \
  '    echo "    \"node_modules/$name\": {"' \
  '    echo "      \"version\": \"$ver\","' \
  '    echo "      \"resolved\": \"https://registry.npmjs.example/$name/-/$name-$ver.tgz\","' \
  '    echo "      \"integrity\": \"sha512-$sum\""' \
  '    echo "    }$sep"' \
  '  done' \
  '  echo "  }"' \
  '  echo "}"' \
  '} > package-lock.json' \
  'echo "package-lock.json updated ($n packages)"'
chmod +x tools/lock.sh
pkg_json '"accounting": "^0.4.1"' '"lodash": "^4.17.21"' '"zod": "^3.22.4"'
./tools/lock.sh >/dev/null
page_js "" "'<p>' + review.text + '</p>'"
as maya; commit "Brightcart 1.5.0"

# your branch: render review text as Markdown
git switch -q -c feature/review-markdown
as you
pkg_json '"accounting": "^0.4.1"' '"lodash": "^4.17.21"' '"marked": "^12.0.0"' '"zod": "^3.22.4"'
./tools/lock.sh >/dev/null
commit "Add marked dependency"
page_js "const { marked } = require('marked');" "'<p>' + marked.parseInline(review.text) + '</p>'"
commit "Render review text as Markdown"

# meanwhile on main: review dates
git switch -q main
as lena
pkg_json '"accounting": "^0.4.1"' '"dayjs": "^1.11.10"' '"lodash": "^4.17.21"' '"zod": "^3.22.4"'
./tools/lock.sh >/dev/null
commit "Add dayjs dependency"
page_js "const dayjs = require('dayjs');" "'<p>' + review.text + '</p><small>' + dayjs(review.date).format('MMM D, YYYY') + '</small>'"
commit "Show review dates"

git switch -q feature/review-markdown
as you
remember feature feature/review-markdown
remember main main
