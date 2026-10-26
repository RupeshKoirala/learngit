Start with the range: `git log --oneline v1.4.0..v1.5.0`. Two dots mean "reachable from v1.5.0 but not from
v1.4.0" — exactly the commits in this release. Add `--no-merges` to drop the "Merge pull request" commits.
---
Print just subjects and filter by type:
`git log --no-merges --format=%s v1.4.0..v1.5.0 --grep '^feat' -E`. `--grep` searches the whole message, so
anchor with `^`. Strip the prefix with sed: `| sed -E 's/^[a-z]+(\([^)]*\))?!?: //'`.
---
A breaking change can hide in the body. `--grep` matches any line of the message, so
`git log --no-merges --format=%s v1.4.0..v1.5.0 -E --grep '^[a-z]+(\(.*\))?!:' --grep '^BREAKING CHANGE:'`
finds both kinds (multiple `--grep`s are OR-ed). `git log --format=%B` shows full messages if you want to look.
---
You should end up with 4 features, 3 fixes and 2 breaking changes. Build the section in a temp file, then put it
above the old one, e.g. `{ echo "# Changelog"; echo; cat new.md; tail -n +3 CHANGELOG.md; } > tmp && mv tmp CHANGELOG.md`,
check it with `git diff`, and commit (`docs: changelog for v1.5.0`).
