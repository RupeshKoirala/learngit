cd repo
staged=$(git diff --staged --name-only | sort)
unstaged=$(git diff --name-only | sort)
q1=$(printf '%s\n' "$staged" "$unstaged" | sort | uniq -d | head -1)
q2=$(git diff --word-diff=porcelain README.md | sed -n 's/^+//p' | grep -v '^++' | head -1)
q3=$(git diff --name-only main...feature/gift-cards | wc -l | tr -d ' ')
q4=$(git diff --numstat v1.0 v1.1 -- src/cart.js | cut -f1)
printf 'q1=%s\nq2=%s\nq3=%s\nq4=%s\n' "$q1" "$q2" "$q3" "$q4" > ../ANSWER
