cd repo
m=$(git log --format=%H --merges -1 --grep='#42' main)
git switch -q release/2.4
git cherry-pick -x -m 1 "$m" >/dev/null
msg=$(git log -1 --format=%B | sed '1s/.*/Add wishlist (backport of PR #42)/')
git commit -q --amend -m "$msg"
