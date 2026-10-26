cd repo
q1=$(git log -L :calculateTax:src/tax.js -s --format=%H | grep -c '^[0-9a-f]\{40\}$')
r=$(git log -L :calculateTax:src/tax.js --format='commit %H' | awk '
  /^commit / { h = $2; r = 0; f = 0 }
  /^-.*Math\.round/  { r = 1 }
  /^\+.*Math\.floor/ { f = 1 }
  r && f { print h; exit }')
git tag rounding-change "$r"
q2=$(git show --name-only --format= "$r" | grep -c .)
q3=$(git grep -l TAX_RATE_EU v1.0 | head -1 | sed 's/^v1\.0://')
printf 'q1=%s\nq2=%s\nq3=%s\n' "$q1" "$q2" "$q3" > ../ANSWER
