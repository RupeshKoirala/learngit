Work inside the folder: `cd shop`, then `git init`. Run `git status` often — it tells you which branch
you're on and which files Git sees. Your machine may default to `master`; `git init -b main` names the branch
for you (or rename it later with `git branch -m main`).
---
Without `--global`, `git config` writes to `.git/config` of the current repository:

```bash
git config user.name  "Your Name"
git config user.email "you@example.com"
git config --local --list      # see what's set for this repo only
```
---
A `.gitignore` is a plain text file with one pattern per line. A trailing `/` means "a directory",
`*` is a wildcard. Create it **before** your first `git add .` and check with `git status` that the
secrets and `node_modules/` are no longer listed.

```
node_modules/
.env
*.log
```
`.env` only matches a file named exactly `.env`, so `.env.example` stays visible.
---
```bash
git add .gitignore && git commit -m "Add .gitignore"
git status                     # only project files should be listed now
git add . && git commit -m "Add storefront prototype"
git log --oneline --stat       # double-check: no .env, no node_modules
```
Committed a secret by accident? `git rm --cached .env`, then `git commit --amend` — fine while
nothing is pushed. Or delete `.git` and start over: `rm -rf .git`.
