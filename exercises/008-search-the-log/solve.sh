cd repo
git tag lena-first     "$(git log --author=Lena --reverse --format=%H | head -1)"
git tag march-hotfix   "$(git log --since=2025-03-01T00:00:00Z --until=2025-03-07T23:59:59Z --format=%H)"
git tag issue-42       "$(git log --grep='#42' --format=%H)"
git tag tax-file       "$(git log --diff-filter=A --format=%H -- src/tax.js)"
git tag freeship-added "$(git log -S FREESHIP50 --reverse --format=%H | head -1)"
