cd repo
# The branch reflog: @{0} rebase (finish), @{1} the original tip (the no-op reset only shows in HEAD's reflog).
git tag before-rebase 'feature/returns@{1}'
git reset -q --hard before-rebase
git rebase main >/dev/null 2>&1 || true          # README.md conflict
git show main:README.md > README.md
append README.md "" "Returns: accepted within 30 days of delivery."
git add README.md
git rebase --continue >/dev/null
