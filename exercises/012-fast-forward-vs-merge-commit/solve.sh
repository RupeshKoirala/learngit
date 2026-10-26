cd repo
git switch -q main
git merge -q --ff-only fix/price-rounding
git merge -q --no-ff --no-edit feature/gift-wrap
if git merge -q --ff-only feature/loyalty-points 2>/dev/null; then echo "ff-only should have refused" >&2; exit 1; fi
git merge-base main feature/loyalty-points > ../ANSWER
