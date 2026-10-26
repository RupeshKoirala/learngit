# Solution

```bash
git ls-remote origin                       # ... refs/pull/42/head, refs/pull/43/head
git fetch origin pull/42/head:pr-42
git switch pr-42
git log --oneline main..pr-42              # Lena's 2 commits
git diff main...pr-42                      # just the PR's changes
./test.sh                                  # tests FAILED (leftover "BUG?" marker)
cat docs/shipping.md                       # "$50.00 or more ship free"

cat > ../ANSWER <<'TXT'
request changes
src/shipping.js: spec (docs/shipping.md) says orders of $50.00 *or more* ship free, but the code uses
`total > FREE_SHIPPING_FROM`, so an order of exactly 5000 cents still pays $5.99. Use `>=`.
src/shipping.js: remove the "BUG?" comment — ./test.sh fails on it. A test for 4999 / 5000 / 5001 would pin this down.
README change looks good.
TXT

git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git fetch                                  # * [new ref] refs/pull/42/head -> origin/pr/42 …
git switch main
```

**Why it works:** a **refspec** `src:dst` tells fetch which remote refs to copy to which local refs.
`pull/42/head:pr-42` is a one-off (`pull/42/head` is resolved to `refs/pull/42/head` on the server, `pr-42` becomes
`refs/heads/pr-42`). Adding `+refs/pull/*/head:refs/remotes/origin/pr/*` to `remote.origin.fetch` makes it permanent;
the `+` allows non-fast-forward updates, which you need because PR authors force-push. Because the PR lands in
`refs/remotes/…`, it's read-only-ish: you can't accidentally commit to it.

**Real-world notes**
- With the GitHub CLI: `gh pr checkout 42` does the fetch + branch for you (and can push back to the author's fork
  if they allowed maintainer edits — don't, unless asked).
- GitHub also has `refs/pull/<n>/merge`: the PR **pre-merged into the target branch**. That's what CI usually tests;
  fetch it to reproduce "passes on the branch, fails after merge".
- Review in this order: does it match the spec (PM-aware!) → tests → readability → style. Lead with the blocking
  issue, label nits as nits, and suggest the fix (`>=`) instead of only pointing at the problem.
- Boundaries (`>` vs `>=`) are the #1 pricing bug. Ask for a test at the exact threshold; it's cheap and permanent.
- On GitLab the equivalent hidden ref is `refs/merge-requests/<n>/head`.
