# Solution

```bash
cd shop
git init -b main                       # older Git: git init && git branch -m main (after 1st commit)
git config user.name  "Your Name"      # no --global: stored in .git/config
git config user.email "you@example.com"

cat > .gitignore <<'IGN'
# dependencies
node_modules/

# secrets
.env

# logs
*.log
IGN

git status                             # .env, node_modules/, npm-debug.log are gone from the list
git add .gitignore
git commit -m "Add .gitignore"
git add .
git status                             # read the "Changes to be committed" list BEFORE committing
git commit -m "Add storefront prototype"
git log --oneline --stat
```

**Why it works:** `git init` creates the hidden `.git/` folder — that folder *is* the repository; the files
around it are just your working tree. Git config has layers: `--system` < `--global` (`~/.gitconfig`) <
`--local` (`.git/config`); the most specific one wins, so a local identity overrides your global one in this
repo only. `.gitignore` only affects **untracked** files, which is why it must exist *before* the first
`git add .` — once a file is committed, ignoring it does nothing (exercise 006).

**Real-world notes**
- Create `.gitignore` as the very first commit of every project. GitHub's "Add .gitignore" templates
  (`github/gitignore`) are a good starting point; `gitignore.io` generates combined ones.
- Two identities (work and personal)? Instead of setting `user.email` in every repo, use conditional
  includes in `~/.gitconfig`: `[includeIf "gitdir:~/work/"] path = ~/.gitconfig-work`.
- Your commit email is public on GitHub. Use your `…@users.noreply.github.com` address for open-source
  work if you don't want it scraped.
- Secrets that reach a commit must be treated as **leaked**, even if you remove them later — history keeps
  them, and pushes are copied everywhere. Rotate the key first, then clean history (exercise on
  `filter-repo`). Ship a `.env.example` so newcomers know which variables exist.
- `git add .` is fine for a first commit *after* checking `git status`. In daily work prefer
  `git add <paths>` or `git add -p` (exercises 002–003) so unrelated changes don't sneak in.
