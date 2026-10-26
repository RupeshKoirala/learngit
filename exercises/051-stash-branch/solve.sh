cd repo
s=$(git stash list --format='%gd %gs' | grep loyalty | cut -d' ' -f1)
git stash branch feature/loyalty-points "$s" >/dev/null
git add -A
git commit -q -m "Add loyalty points to checkout"
