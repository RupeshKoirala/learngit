# Get node_modules/ and dist/ out of your branch's history

You ran `npm install && npm run build && git add -A && git commit`. The repo's `.gitignore` didn't ignore
`node_modules/` or `dist/` (the project only recently got a build step), so 33 dependency files and a minified
bundle went into your branch. Before opening the PR, `git show --stat HEAD~2` says `36 files changed`.

```
* Document search        <- feature/search (NOT pushed)   also adds dist/bundle.js.map
* Debounce search input
* Add product search                                     adds src/search.js + node_modules/** + dist/bundle.js
* Add search index
* Initial storefront     <- main, origin/main
```

Deleting them in a 5th commit isn't good enough: they'd still be in the history and the PR.

## Your task

On `feature/search`:

1. No commit on any branch (and no backup ref) contains `node_modules/` or `dist/` anymore.
2. Your 4 commits survive with the same messages, in order, each exactly once (one extra commit for the ignore
   rules is fine). The code, `package.json`, `package-lock.json` and README are unchanged — lockfiles **do**
   belong in Git.
3. `.gitignore` on the branch ignores `node_modules/` and `dist/`.
4. The files stay on your disk (`node_modules/fuzzy-lite/index.js`, `dist/bundle.js`) — you still need them to run
   the app — and the working tree is clean.
5. `main` and `origin/main` don't change.

## You'll practice

`git rm -r --cached`, `git rebase -x` / `git rebase -i` with `edit`, `git commit --amend`, `.gitignore`,
`git check-ignore`, and when (not) to reach for `git filter-repo`.
