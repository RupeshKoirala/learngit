cd repo
git switch -q main
git cherry-pick "$(git log --format=%H --grep='^Fix formatPrice for negative amounts$' feature/gift-cards)" >/dev/null
