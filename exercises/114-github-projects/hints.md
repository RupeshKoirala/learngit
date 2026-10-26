```
gh project create --owner "@me" --title "Brightcart v1.1"      # prints the URL; the number is at the end
gh project link <number> --owner "@me" --repo <you>/learngit-lab
gh project item-add <number> --owner "@me" --url https://github.com/<you>/learngit-lab/issues/1
```
---
Setting a field needs IDs: the project's node id, the item id, the field id and the option id.

```
gh project view <number> --owner "@me" --format json --jq .id                          # PVT_...
gh project field-list <number> --owner "@me" --format json --jq '.fields[] | select(.name=="Status")'
gh project item-list <number> --owner "@me" --format json --jq '.items[] | {id, title, status}'
```
---
```
gh project item-edit --project-id PVT_... --id PVTI_... --field-id PVTSSF_... --single-select-option-id <option id>
```
Or open the board (`gh project view <number> --owner "@me" --web`) and drag cards between columns - same result.
---
Milestone due date (ISO 8601, UTC):

```
gh api 'repos/{owner}/{repo}/milestones?state=all' --jq '.[] | [.number, .title] | @tsv'
gh api -X PATCH repos/{owner}/{repo}/milestones/<n> -f due_on=2026-12-15T00:00:00Z
```
(no milestone yet? `gh api repos/{owner}/{repo}/milestones -f title=v1.1 -f due_on=2026-12-15T00:00:00Z`)
