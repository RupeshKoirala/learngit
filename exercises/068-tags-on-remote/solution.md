# Solution

```bash
git for-each-ref refs/tags --format='%(refname:short) %(objecttype)'   # tag = annotated, commit = lightweight
git ls-remote --tags origin                                           # what the server has

# 1. release tag: annotated, pushed alone
git tag -a v2.4.0 -m "Brightcart 2.4.0" main
git push origin v2.4.0

# 2. fix the wrong tag
git log --oneline -4 v2.4.0                     # find "Bump version to 2.3.1"
git show v2.3.1:VERSION                         # 2.3.0  <- proof it's wrong
git push origin --delete v2.3.1                 # remove it on the server
git tag -f -a v2.3.1 -m "Brightcart 2.3.1" <hash-of-bump-commit>
git push origin v2.3.1

# 4. everyone who fetched the old tag keeps it until they force-update
cd ../.team/dev
git fetch --tags                                # ! [rejected] v2.3.1 (would clobber existing tag)
git fetch --tags --force                        # t [tag update] v2.3.1 -> v2.3.1
```

**Why it works:** a lightweight tag is just a ref to a commit; an annotated tag is a real object with tagger, date
and message (and optionally a signature) — that's what releases should use, and what `git describe` and
`--follow-tags` look at. `git push origin <tag>` sends exactly one ref; `git push --tags` sends every tag under
`refs/tags`, private ones included. Servers and clients treat tags as **immutable by default**: pushing a changed tag
is rejected unless forced/deleted first, and `git fetch` refuses to overwrite a tag you already have (since Git 2.20).

**Why moving tags is dangerous:** everyone who already fetched `v2.3.1` keeps the *old* one forever unless they
force-fetch, so "v2.3.1" now means two different things on different machines. CI caches, package registries,
Go modules / npm / Docker images built from the tag, and changelogs all pinned the old commit. Here the tag was a
few minutes old and the fix was communicated; for anything that was really consumed, **don't move it — release
`v2.3.2`** instead.

**Real-world notes**
- Use `git push --follow-tags` (or `git config --global push.followTags true`): it pushes annotated tags that point
  into the commits you're pushing — never your lightweight bookmarks.
- Keep private bookmarks as branches or prefix them (`tmp/…`) and delete them when done: `git tag -d tmp-before-refactor bisect-good`.
- Protect release tags on GitHub with a **tag ruleset** (restrict creation, updates and deletion of `v*`), and
  create them from CI or `gh release create` so they're consistent and signed (`git tag -s`).
- `git ls-remote --tags origin` is the ground truth when someone says "the tag is wrong".
