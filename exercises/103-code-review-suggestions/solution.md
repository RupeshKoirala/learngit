# Solution

```bash
cd "$(./lg where)"
gh pr create --head feature/free-shipping --base main \
  --title "Add free shipping threshold" --body "Orders of \$50+ ship free (spec from Sam). Authored by Lena."
gh pr view --web          # -> Files changed
```

In **Files changed**, click **+** on line 6 (`if (total > FREE_SHIPPING_FROM) return 0;`), write:

````
Spec says "$50.00 or more", so exactly 5000 cents must ship free.
```suggestion
  if (total >= FREE_SHIPPING_FROM) return 0;
```
````

**Start a review** -> **Finish your review** -> **Comment** -> **Submit review**. Then on the comment:
**Commit suggestion** -> **Commit changes**, and **Resolve conversation**.

Locally, pick up the commit GitHub made:

```bash
gh pr checkout <N>        # or: git switch feature/free-shipping && git pull
git log --oneline -2      # "Update src/shipping.js" on top of Lena's commit
gh pr merge <N> --squash --delete-branch    # optional
```

Terminal-only alternative for step 2: `gh api repos/{owner}/{repo}/pulls/<N>/reviews -f event=COMMENT ...`
with a `comments[]` entry (see hint 4). `gh pr review <N> --comment -b "..."` submits a review too, but only
with a top-level body - it can't place line comments.

**Why it works:** a review bundles many line comments into one notification. A ```` ```suggestion ```` block
is just Markdown that GitHub renders as a diff of the commented lines; "Commit suggestion" creates a commit on
the PR branch authored by the reviewer and co-authored by the PR author. Threads stay "open" until someone
resolves them - the check reads them through the GraphQL API (`reviewThreads.isResolved`).

**Real-world notes**
- **Comment** = feedback, no verdict. **Approve** = good to merge. **Request changes** = blocks merging (with
  branch protection) until that reviewer approves. You can't approve your own PR - that's the point.
- Batch your comments in one review; label their weight: `nit:` (optional), `question:`, `blocking:`.
  Explain *why* (link the spec), suggest *how*. Praise good stuff too.
- Etiquette: the **author** resolves a thread after addressing it (or replies why not); the reviewer
  re-reviews. Some teams require "all conversations resolved" in branch protection.
- Use suggestions for small, mechanical fixes. Batch several with "Add suggestion to batch" -> one commit.
- Review locally for anything non-trivial: `gh pr checkout N`, run tests, `gh pr diff N`.
- With branch protection, pushing new commits can **dismiss stale approvals** - re-request review after
  big changes.
