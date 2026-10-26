cd repo
first=$(git log --reverse --format=%H --grep='^a11y:' feature/checkout-redesign | head -1)
last=$(git log --format=%H --grep='^a11y:' feature/checkout-redesign | head -1)
git switch -q release/2.0
git cherry-pick "$first^..$last" >/dev/null
git switch -q main
git cherry-pick -n "$first^..$last" >/dev/null
git commit -q -m "Accessibility fixes for checkout audit"
