cd repo
todo=$(mktemp)
# `exec git commit --amend -m` after a pick does the same as `reword`, without an interactive editor.
git log --reverse --format='%h %s' main..HEAD | awk '
  / asdf$/                 { print "pick " $0; print "exec git commit -q --amend -m \"Add wishlist module\""; next }
  /Document the wishlist$/ { doc = $0; next }
  / temp debug$/           { print "drop " $0; next }
  / add btn$/              { print "pick " $0; print "exec git commit -q --amend -m \"Add wishlist button to product page\""; next }
  END                      { print "pick " doc }' > "$todo"
GIT_SEQUENCE_EDITOR="cp $todo" git rebase -q -i main
