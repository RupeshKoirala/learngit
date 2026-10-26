cd repo
lost=$(git log -g --format='%H %gs' | awk '/commit: Add review moderation queue/ { print $1; exit }')
git cherry-pick "$lost~2..$lost" >/dev/null
