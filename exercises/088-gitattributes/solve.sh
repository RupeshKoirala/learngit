export GIT_CONFIG_GLOBAL=/dev/null
cd repo
git ls-files --eol >/dev/null
write .gitattributes \
  "# Line endings: auto-detect text, store and check out LF everywhere" \
  "* text=auto eol=lf" \
  "*.bat text eol=crlf" \
  "" \
  "# Binary assets: never convert, never diff" \
  "*.png binary" \
  "" \
  "# Build output: collapsed in GitHub PRs, no textual diff" \
  "dist/** linguist-generated=true -diff" \
  "" \
  "# Not part of release archives" \
  "tests/ export-ignore" \
  ".github/ export-ignore" \
  ".gitattributes export-ignore"
git add --renormalize .
git add .gitattributes
git commit -q -m "chore: normalize line endings with .gitattributes"
git rm -r -q --cached .
git reset -q --hard
