# Solution

```bash
gh auth refresh -s project
cd "$(./lg where)"
ME=$(gh api user -q .login)

gh project create --owner "@me" --title "Brightcart v1.1"
N=$(gh project list --owner "@me" --format json --jq '.projects[] | select(.title=="Brightcart v1.1") | .number')
gh project link "$N" --owner "@me" --repo "$ME/learngit-lab"

for url in $(gh issue list --state all --limit 3 --json url --jq '.[].url'); do
  gh project item-add "$N" --owner "@me" --url "$url"
done

PID=$(gh project view "$N" --owner "@me" --format json --jq .id)
FIELD=$(gh project field-list "$N" --owner "@me" --format json --jq '.fields[] | select(.name=="Status") | .id')
opt() { gh project field-list "$N" --owner "@me" --format json \
          --jq ".fields[] | select(.name==\"Status\") | .options[] | select(.name==\"$1\") | .id"; }
set -- $(gh project item-list "$N" --owner "@me" --format json --jq '.items[].id')
gh project item-edit --project-id "$PID" --id "$1" --field-id "$FIELD" --single-select-option-id "$(opt Todo)"
gh project item-edit --project-id "$PID" --id "$2" --field-id "$FIELD" --single-select-option-id "$(opt 'In Progress')"
gh project item-edit --project-id "$PID" --id "$3" --field-id "$FIELD" --single-select-option-id "$(opt Done)"

MS=$(gh api 'repos/{owner}/{repo}/milestones?state=all' --jq '.[] | select(.title=="v1.1") | .number')
gh api -X PATCH "repos/{owner}/{repo}/milestones/$MS" -f due_on=2026-12-15T00:00:00Z
gh project view "$N" --owner "@me" --web
```

**Why it works:** a Project (v2) is its own object owned by a user/org; items reference issues/PRs by URL.
Fields like Status are single-select fields whose options have IDs, which is why the CLI needs four IDs to
set a value (the web board hides that). Linking makes the project appear on the repo. The milestone due date is
plain repo metadata set through the REST API.

**Real-world notes**
- Turn on the project's built-in **workflows**: "item added -> Todo", "PR merged / issue closed -> Done",
  "auto-add issues from repo X with label Y" - the board then mostly maintains itself.
- Add fields PMs actually use: **Priority**, **Size/Estimate**, **Iteration** (sprints), **Target date**.
  Create views: a board by Status for stand-up, a table grouped by Assignee for load, a **roadmap** by
  Iteration/date for stakeholders.
- Milestone = release scope + date (shows % done on the milestone page); Project = workflow state across
  repos. Using both answers "what" and "where are we".
- Engineers can live in the terminal: `gh project item-list` in scripts/stand-up bots, `gh issue develop N -c`
  to create a linked branch so the board shows the work in progress.
- Org projects (`--owner my-org`) are what teams share; personal ones are for your own planning.
