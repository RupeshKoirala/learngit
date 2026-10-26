cd repo
todo=$(mktemp)
git log --reverse --format='%h %s' main..HEAD | awk '
  /Document discount codes/ { doc=$0; next }
  NR==1 { print "reword " $0; next }
  { print "fixup " $0 }
  END { print "pick " doc }' > "$todo"
GIT_SEQUENCE_EDITOR="cp $todo" GIT_EDITOR="printf '%s\n' 'Add discount code support' >" git rebase -q -i main
