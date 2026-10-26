# Solution

```bash
cd "$(./lg where)"                 # ~/learngit-playground/github-lab
gh auth status                     # logged in? which account, protocol, scopes?
# not logged in:  gh auth login    (GitHub.com, HTTPS, "authenticate Git" = yes)

gh repo create learngit-lab --private --source=. --remote=origin --push
gh repo edit --description "Brightcart storefront - my Git/GitHub practice lab" \
             --add-topic git --add-topic brightcart
git branch -vv                     # main [origin/main] ...
gh repo view --web
```

**Why it works:** `--source=.` tells gh to use the existing repository instead of cloning an empty one.
gh creates the repo through the API, adds it as the remote named by `--remote`, and `--push` runs
`git push --set-upstream origin HEAD`, so `main` immediately tracks `origin/main`. `gh repo edit` with no
repo argument works on the repo of the current directory (it reads `origin`).

**Real-world notes**
- `gh auth login` stores a token and, with "authenticate Git", runs `gh auth setup-git` so plain `git push`
  over HTTPS uses that token. Prefer SSH? `gh auth login -p ssh` can upload your key too.
- Token **scopes** decide what gh may do: the default (`repo`, `read:org`, `gist`, `workflow`) covers most of
  this module; GitHub Projects need `gh auth refresh -s project`. `gh auth status` lists them.
- Private vs public: private is the safe default for company code. Some features (branch protection, rulesets,
  secret scanning) need a paid plan on *private* repos - on GitHub Free you'd make a demo repo public instead.
- Description and topics aren't vanity: in an org with hundreds of repos, topics are how people (and
  `gh search repos topic:payments`) find the right one. Add a README, a LICENSE decision and a CODEOWNERS
  file (exercise 108) to every new repo.
- Creating from scratch instead: `gh repo create brightcart --private --clone` (or `--template owner/tpl`
  to start from an org template repository).
