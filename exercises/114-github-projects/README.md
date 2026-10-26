# Plan work like a PM

Sam (PM) asks the question every lead hears weekly: *"What's in v1.1, what's in flight, and are we on track
for the date?"* Answer it with a board everyone can see instead of a status meeting.

**GitHub Projects** are boards/tables over issues and PRs from any repo, with custom fields. **Milestones**
group a repo's issues into a release with a due date.

> Needs the `project` token scope: `gh auth refresh -s project`

## Your task

1. Create a GitHub Project (owned by you) titled exactly **`Brightcart v1.1`**.
2. **Link** it to the `learngit-lab` repo (so it shows up in the repo's Projects tab).
3. Add **at least 3 issues** from `learngit-lab` to it (closed ones count - create more with `gh issue create` if needed).
4. Use the built-in **Status** field so the board has at least one item in each of **Todo**, **In Progress** and **Done**.
5. Give the milestone **`v1.1`** a **due date** (create the milestone if exercise 102 didn't).

## You'll practice

`gh project create / link / item-add / item-list / field-list / item-edit`, project node IDs, single-select
fields, `gh api -X PATCH .../milestones/N -f due_on=...`, board vs table views.
