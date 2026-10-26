# Solution

```bash
git log --oneline v2.0.0..main                    # what must NOT ship (loyalty, carriers, 2.1.0-dev)
git switch -c hotfix/2.0.1 v2.0.0

# edit src/shipping.js:  totalCents >= FREE_SHIPPING_FROM
./test.sh
git commit -am 'fix(shipping): free shipping from exactly $50'
echo 2.0.1 > VERSION
git commit -am "chore(release): 2.0.1"
git tag -a v2.0.1 -m "Brightcart 2.0.1"
git diff --stat v2.0.0 v2.0.1                     # review: 2 files, 2 lines. Nothing else sneaks in.

git switch main
git cherry-pick -x hotfix/2.0.1~1                 # forward-port only the fix, not the version bump
git push origin main hotfix/2.0.1 v2.0.1
```

Alternative forward-port: `git merge hotfix/2.0.1` → `VERSION` conflicts → `git checkout --ours VERSION`,
`git add VERSION`, `git commit`. Both are accepted.

**Why it works:** a tag is an immutable name for what's in production, so branching from it gives you
production's exact code with none of `main`'s unreleased work. Cherry-pick isn't "copy this diff": it's a
3-way merge with the fix's parent as the base, which is why it applies cleanly on `main` even though Dev
changed other lines of `shipping.js` since 2.0.0. Splitting fix and version bump into two commits is what makes
the cherry-pick conflict-free.

**Real-world notes**
- **Minimal diff, maximal confidence.** `git diff --stat v2.0.0 v2.0.1` is what you paste into the change
  ticket. A hotfix that "also fixes a few small things" is how a 2-line release becomes an incident.
- **Don't forget the forward-port.** The classic failure is: hotfix ships, nobody ports it, 2.1 ships and the
  bug is *back* ("regression from 2.0.1"). Make it part of your hotfix checklist, or adopt **upstream first**
  (fix on `main`, cherry-pick to the hotfix branch) so it can't be forgotten.
- **cherry-pick -x vs merge.** `-x` gives traceability ("cherry picked from …") and keeps `main`'s history free
  of the hotfix branch. Merging records the relationship in the graph, so tools like `git branch --contains`
  and `git tag --contains` work across branches — but you'll fight `VERSION`/changelog conflicts every time.
  Many teams cherry-pick into `main` and merge only release branches.
- **Prove it:** `git tag --contains <fix>` and `git branch -a --contains <fix>` answer "which releases have the
  fix?" — the first question every incident review asks.
- On GitHub: protect `hotfix/*` like `main`, open a PR for the hotfix too (yes, even on Friday), then
  `gh release create v2.0.1 --notes "Fix: free shipping for orders of exactly \$50"`.
