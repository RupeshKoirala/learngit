cd repo
todo=$(mktemp)
git log --reverse --format='%h %s' main..HEAD | awk '
  /star rating widget/ { print "edit " $0; next }
  { print "pick " $0 }' > "$todo"
GIT_SEQUENCE_EDITOR="cp $todo" git rebase -q -i main     # stops after replaying the mixed commit
git reset -q HEAD^
git add src/price.js
git commit -q -m "Fix price rounding for fractional cents"
git add src/rating.js
git commit -q -m "Add star rating widget"
git rebase --continue >/dev/null
