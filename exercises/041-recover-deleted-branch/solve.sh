cd repo
# find the reflog entry where we left the branch; the entry right after it (older) is the branch tip
n=$(git reflog --format='%gd %gs' | awk '/moving from feature\/wishlist to/ { sub(/^HEAD@\{/,"",$1); sub(/\}$/,"",$1); print $1; exit }')
git branch feature/wishlist "HEAD@{$((n + 1))}"
