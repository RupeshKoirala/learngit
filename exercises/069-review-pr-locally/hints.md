See what the server has, hidden refs included: `git ls-remote origin`. You can fetch any ref by name and store it
under a local branch: `git fetch origin <remote-ref>:<local-branch>`.
---
`git fetch origin pull/42/head:pr-42` then `git switch pr-42`. Review it: `git log --oneline main..pr-42`,
`git diff main...pr-42` (three dots = only the PR's own changes), `./test.sh`, `cat docs/shipping.md`.
---
Compare the condition in `src/shipping.js` with the spec: what does an order of exactly 5000 cents pay? And the
test runner fails on a leftover marker. Your ANSWER could look like:
```
request changes
src/shipping.js: spec says $50.00 *or more* ships free, code uses > 5000; should be >= (and remove the BUG? comment, tests fail)
```
---
Refspec for all PRs:
`git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'` then `git fetch`.
`--add` matters: it keeps the normal `+refs/heads/*:refs/remotes/origin/*` line.
