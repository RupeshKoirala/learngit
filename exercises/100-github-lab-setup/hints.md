Work inside the lab: `cd "$(./lg where)"`. Then `gh auth status` tells you whether you're logged in, which
account, which protocol (HTTPS/SSH) and which token scopes you have.
---
`gh repo create` has a mode for "I already have a local repository". Look at `gh repo create --help` for the
flags `--source`, `--private`, `--remote` and `--push`.
---
```
gh repo create learngit-lab --private --source=. --remote=origin --push
```
Then look at `gh repo edit --help` for `--description` and `--add-topic`.
---
```
gh repo edit --description "Brightcart storefront - my Git/GitHub practice lab" --add-topic git --add-topic brightcart
gh repo view --web     # see it in the browser
```
If the push failed because of credentials: `gh auth setup-git`, then `git push -u origin main`.
