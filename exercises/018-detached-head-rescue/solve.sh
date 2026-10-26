cd repo
lost=$(git log -g --format='%h %gs' HEAD | awk '$2 == "commit:" && $0 ~ /Fix coupon expiry off-by-one$/ { print $1; exit }')
git branch hotfix/1.2.1 "$lost"
