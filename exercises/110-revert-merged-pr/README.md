# Revert a merged PR, then re-land it

Maya's **`feature/express-checkout`** is ready (tests pass, CI green). You ship it...

...and ten minutes later Sam (PM) pings: *"Guest customers have no saved address - express orders are being
created with `address: undefined`! Roll it back NOW."*

Rule #1 of incidents: **restore service first, debug second.** Don't hot-patch under pressure; revert the PR
(a new commit that undoes it - history stays honest, nothing is force-pushed). Then fix calmly and re-land.

## Your task

1. Open a PR for `feature/express-checkout` and **merge** it.
2. **Revert it** through a second PR and merge that: GitHub's **Revert** button on the merged PR (it creates a
   `revert-<N>-...` branch and PR), or `git revert` on a branch + `gh pr create`. Its title starts with
   `Revert`.
3. **Re-land** the feature in a **third** PR, merged after the revert, that brings `src/express.js` back
   **with a fix**: a `validateAddress(...)` function that throws when the address is missing, used by
   `expressCheckout`. Tip: start the branch with `git revert <the revert commit>` ("revert the revert").

## You'll practice

`gh pr merge`, the Revert button / `git revert <sha>` / `git revert -m 1 <merge>`, "revert the revert",
incident communication, `gh pr list --state merged`.
