cd repo
git rebase -x ./test.sh main >/dev/null 2>&1 || true    # stops after the first failing commit
git rev-parse HEAD > ../ANSWER
git rebase --abort
todo=$(mktemp)
git log --reverse --format='%h %s' main..HEAD | awk '
  /Export loyalty helpers$/ { next }
  { print "pick " $0 }
  /Add loyalty points calculator$/ { print "fixup " fx }
  { print "exec ./test.sh" }' fx="$(git log --format='%h %s' --grep='^Export loyalty helpers$' main..HEAD)" > "$todo"
GIT_SEQUENCE_EDITOR="cp $todo" git rebase -q -i main >/dev/null
