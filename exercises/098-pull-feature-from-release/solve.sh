cd repo
git switch -q release/2.3
list=$(git log --format=%h --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)
body=$(git log --format='Reverts %h %s' --fixed-strings --grep '(giftcards)' v2.2.0..release/2.3)
# shellcheck disable=SC2086
git revert --no-commit $list
tick; git commit -q -m "Revert gift cards from 2.3 (Legal sign-off pending)" -m "$body"
