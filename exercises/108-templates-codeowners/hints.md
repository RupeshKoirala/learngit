Branch `chore/templates`, create the files, one commit, `git push -u origin HEAD`, `gh pr create --fill`.
Notice: the PR you open *with* the template file doesn't use it yet - templates are read from the default branch.
---
A minimal issue form:

```yaml
name: Bug report
description: Something is broken
labels: ["bug"]
body:
  - type: textarea
    id: steps
    attributes:
      label: Steps to reproduce
    validations:
      required: true
```
---
CODEOWNERS: last matching pattern wins.

```
*        @your-login
/src/    @your-login
```
For a team in an org it'd be `@brightcart/checkout-team`. Owners must have write access.
---
After merging: `gh api repos/{owner}/{repo}/codeowners/errors` should print `{"errors":[]}`.
`gh issue create --web` opens the template chooser.
