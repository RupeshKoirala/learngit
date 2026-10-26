cd repo
sha=$(git log --no-walk --format='%H %s' $(git fsck --no-reflogs --unreachable 2>/dev/null | awk '/commit/ {print $3}') \
      | awk '/ On main: express checkout button$/ { print $1; exit }')
git stash apply -q "$sha"
