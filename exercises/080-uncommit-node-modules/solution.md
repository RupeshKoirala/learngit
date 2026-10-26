# Solution

```bash
cd repo
git log --oneline --stat main..HEAD -- node_modules dist   # commits 2 and 4 are dirty

git rebase -x 'git rm -r -q --cached --ignore-unmatch node_modules dist && git commit -q --amend --no-edit --allow-empty' main

printf 'node_modules/\ndist/\n' >> .gitignore
git add .gitignore && git commit -m "Ignore node_modules/ and dist/"

git log --all --oneline -- node_modules dist               # nothing
git status                                                 # clean: the folders are ignored now
ls node_modules dist                                       # still on disk
```

The interactive version does the same thing by hand: `git rebase -i main`, mark `Add product search` and
`Document search` as `edit`; at each stop run `git rm -r --cached node_modules dist`,
`git commit --amend --no-edit`, `git rebase --continue`.

**Why it works:** `git rm --cached` removes paths from the index only — the next commit won't contain them, but
your disk keeps them. Doing it while rebase replays each commit (the `-x` command runs after every pick) rewrites
every commit on the branch without the junk. `--ignore-unmatch` makes the command a no-op on clean commits,
and `--allow-empty` covers a commit that contained *only* junk. The rewrite is safe because nothing was pushed.

**Real-world notes**
- **Commit the lockfile, never `node_modules/` or build output.** `package-lock.json` (or `yarn.lock`,
  `pnpm-lock.yaml`) makes installs reproducible; `node_modules` is platform-specific (native binaries!), huge, and
  rebuilt by `npm ci`. Same for `dist/`, `build/`, `target/`, `.venv/`, `__pycache__/`.
- Add ignore rules **before** the first `npm install`. Start from github.com/github/gitignore templates; put personal
  editor junk (`.DS_Store`, `.idea/`) in your global ignore file (`core.excludesFile`), not the project's.
- `.gitignore` only affects **untracked** files. If something is already tracked, ignoring it changes nothing until
  you `git rm --cached` it — the most common "why is my ignore rule not working?" question.
  `git check-ignore -v <path>` tells you which rule matches.
- Already pushed to your own branch? Same fix + `git push --force-with-lease`. Already merged into `main` long
  ago? Then it's exercise 073 territory (`git filter-repo --path node_modules --invert-paths`) with a team-wide re-clone;
  usually it's better to just `git rm -r --cached` in a new commit and accept the history.
- `git filter-repo --refs main..feature/search --path node_modules --path dist --invert-paths --force` can also do
  this branch-only rewrite (it removes `origin`, re-add it). Avoid the deprecated `git filter-branch`; if you use it,
  delete its `refs/original/` backup afterwards or the junk stays reachable.
