# Solution

```bash
cd repo
git pull                                     # fast-forward: now you have Maya's commit too
./test.sh                                    # tests FAILED
git log --oneline -- src/price.js            # the culprit: Add currency support to formatPrice
git revert <bad-hash>                        # new commit: Revert "Add currency support to formatPrice"
./test.sh                                    # tests passed  -> in real life: git push NOW, unblock the release

git show <bad-hash>:src/price.js > src/price.js
# fix:  return symbol + (cents / 100).toFixed(2);
./test.sh
git commit -am "Add currency support to formatPrice (keep cents)"
git push                                     # plain push: you only added commits
git log --oneline -4
# 4444444 Add currency support to formatPrice (keep cents)
# 3333333 Revert "Add currency support to formatPrice"
# 2222222 Show cart total in header
# 1111111 Add currency support to formatPrice
```

**Why it works:** `git revert` computes the inverse diff of a commit and records it as a **new** commit. History
only grows, so everyone who already pulled the bad commit just pulls the revert as a normal fast-forward.
`git reset --hard <before-bad> && git push --force` would also "remove" the bug — and silently delete Maya's commit
from `origin`, leave Lena with commits the server no longer has, and the next person to push from an old clone
would bring the bug straight back.

Revert first, fix second: the revert is tiny, obviously correct and reviewable in seconds, so `main` is green
fast. The real fix can then take the time it needs, with its own review.

**Real-world notes**
- **Communicate**: post in the channel what broke, that the revert is in, and the follow-up PR. A quick
  blameless note beats silent force-pushes.
- On GitHub, merged PRs have a **Revert** button that opens a revert PR — the same thing with review and CI.
- Reverting a *merge commit* needs `git revert -m 1 <merge>`; and if you later re-merge the same branch you must
  "revert the revert" first, or Git thinks those changes are already applied.
- Fix-forward *without* reverting is fine when the fix is a one-liner you're sure of. When in doubt, revert:
  time-to-green matters more than elegance during an incident.
- Prevent it: required CI checks and branch protection on `main` (no direct pushes, no force-push), so a red test
  can't merge in the first place.
