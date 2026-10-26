cd repo
if git push -q 2>/dev/null; then echo "push unexpectedly succeeded" >&2; exit 1; fi
git pull -q --rebase
git push -q
