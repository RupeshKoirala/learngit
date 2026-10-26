# Issues like a team

Sam (PM) runs planning on Monday. Before that, the backlog in your lab needs to look like a real team's:
every issue **labelled**, **assigned**, and grouped into the next release's **milestone** - and the first
bug fixed by a PR that closes its issue automatically.

## Your task

1. Create two labels: **`priority:high`** and **`area:checkout`** (pick any colours/descriptions).
2. Create a milestone **`v1.1`** (gh has no milestone command - use `gh api`, or the web UI).
3. Create **at least 3 issues** that are all in milestone `v1.1`, all **assigned to you**, and each has
   **at least one label**. At least one of them is a bug labelled `priority:high`. Ideas:
   - *Cart total is NaN when an item has no qty* (`bug`, `priority:high`, `area:checkout`)
   - *Add a wishlist* (`enhancement`)
   - *Show "free shipping" hint in the cart* (`enhancement`, `area:checkout`)
4. Fix one of the v1.1 issues in a branch and **merge a PR whose description says `Fixes #N`**, so GitHub
   closes the issue for you (don't close it by hand).

## You'll practice

`gh label create`, `gh api repos/{owner}/{repo}/milestones`, `gh issue create --label --assignee @me
--milestone`, `gh issue edit`, `gh issue list --milestone`, closing keywords, `gh pr merge`.
