cd repo
git fetch -q origin
rd=$(git range-diff --no-color origin/main 'origin/feature/wishlist@{1}' origin/feature/wishlist)
# header lines look like: "3:  da9060a ! 3:  0cb0df1 Cap wishlist size"
# pick the "!" pair whose inner diff touches a file section ("## src/..."), not only "## Commit message ##"
changed=$(printf '%s\n' "$rd" | awk '
  /^[0-9-]+: +[0-9a-f-]+ [=!<>] / { cur = ($3 == "!") ? $5 : ""; sec = ""; next }
  /^ +## Commit message/ { sec = "msg" }
  /^ +## src\//          { sec = "code" }
  cur != "" && sec == "code" && /^    [-+]/ { print cur; cur = "" }' | head -1)
git tag changed-commit "$changed"
cap=$(git show origin/feature/wishlist:src/wishlist.js | sed -n 's/.*MAX_ITEMS = \([0-9]*\).*/\1/p')
dropped=$(printf '%s\n' "$rd" | awk '$3 == "<" { print $2 }')
printf 'cap=%s\ndropped=%s\n' "$cap" "$dropped" > ../ANSWER
