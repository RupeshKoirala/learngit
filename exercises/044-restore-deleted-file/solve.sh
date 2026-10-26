cd repo
d=$(git log --diff-filter=D --format=%h -1 -- src/coupons.js)
echo "$d" > ../ANSWER
git restore --source="$d^" -- src/coupons.js
git add src/coupons.js
git commit -q -m "Restore coupon codes for Black Friday"
