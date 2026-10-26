cd repo
if git push -q 2>/dev/null; then echo "push unexpectedly succeeded" >&2; exit 1; fi
git push -q --force-with-lease
( cd "$LG_DIR" && . "$LG_EX/event.sh" ) >/dev/null
git commit -q --amend -m "Add order note length limit"
if git push -q --force-with-lease 2>/dev/null; then echo "lease push unexpectedly succeeded" >&2; exit 1; fi
git fetch -q
git cherry-pick origin/feature/order-notes >/dev/null
git push -q --force-with-lease
