cd repo
if git rebase -h 2>&1 | grep -q -- '--update-refs'; then
  git switch -q feature/checkout-3-ui
  git rebase -q --update-refs main
else   # Git < 2.38: bottom-up with --onto
  old1=$(git rev-parse feature/checkout-1-model); old2=$(git rev-parse feature/checkout-2-api)
  git rebase -q main feature/checkout-1-model
  git rebase -q --onto feature/checkout-1-model "$old1" feature/checkout-2-api
  git rebase -q --onto feature/checkout-2-api "$old2" feature/checkout-3-ui
fi
