`git tag -n` and `git for-each-ref refs/tags --format='%(refname:short) %(objecttype)'` show which tags are
annotated (`tag`) and which are lightweight (`commit`). `git ls-remote --tags origin` shows what the server has.
`git push --tags` would push **all** of them — including your junk.
---
`git tag -a v2.4.0 -m "Brightcart 2.4.0" main` then `git push origin v2.4.0` (or `git push origin refs/tags/v2.4.0`).
---
Moving a tag: `git tag -f -a v2.3.1 -m "Brightcart 2.3.1" <hash-of-Bump-version-to-2.3.1>`. The server refuses a
normal push of a changed tag ("already exists"); delete it there first with `git push origin --delete v2.3.1`
and push again (or force-push that one tag: `git push --force origin v2.3.1`).
---
In `../.team/dev`: a plain `git fetch --tags` says `! [rejected] v2.3.1 -> v2.3.1 (would clobber existing tag)`.
Git never silently moves a tag you already have. `git fetch --tags --force` (or
`git fetch origin +refs/tags/v2.3.1:refs/tags/v2.3.1`) does it on purpose.
