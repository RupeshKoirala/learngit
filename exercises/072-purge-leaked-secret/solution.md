# Solution

**0. Contain first, clean second.** The key was public the moment it was pushed. Bots scrape GitHub for
credentials within minutes, so rewriting history does *not* un-leak it. Revoke/rotate the key at the provider
(done in the story), check the provider's logs for misuse, *then* clean the repository.

```bash
cd repo
git log --all --oneline -- .env         # blast radius: every commit on every ref that touched .env
git show v0.9:.env                      # still readable from the tag -> a delete commit is useless

git filter-repo --invert-paths --path .env --force
#   --force only because this isn't a fresh clone (see notes)

git remote -v                           # empty: filter-repo removed origin on purpose
git remote add origin ../remotes/origin.git

printf '.env\n.env.*\n' >> .gitignore
git add .gitignore
git commit -m "Ignore .env files"

git push --force origin --all           # main + feature/refunds
git push --force origin --tags          # the rewritten v0.9
git branch -u origin/main

printf 'PAYFLUX_SECRET=pfx_live_R0TATED_51b7c2d9e8\nPAYFLUX_ENV=live\n' > .env
git check-ignore -v .env                # .gitignore:4:.env    .env
git log --all --oneline -- .env         # nothing
```

**Why it works:** a commit's id is a hash of its tree, parents and metadata. To make `.env` disappear,
filter-repo has to create a *new* version of the leaking commit and of every commit after it, on every branch
and tag (that's why every hash from `Add PayFlux payment client` onward changes). `--invert-paths --path .env`
means "keep everything except this path". Afterwards it expires the reflog and runs `gc`, so the old objects
are really gone from *your* clone. It removes `origin` so a half-finished rewrite can't be pushed by accident,
and it wants a fresh clone so you never destroy your only copy of the history.

The force-pushes replace the remote refs. `--all` pushes branches only, so tags need their own push.

**Real-world notes**
- **Rotate before you rewrite.** Rewriting is cleanup; rotation is the fix. If you only have 5 minutes, spend
  them revoking the key. Also rotate everything else that file held — here the DB password `hunter2` leaked too.
- **Every clone still has the secret.** Maya's clone (`.team/maya`), CI caches, forks. Tell the team to
  **re-clone** (or `git fetch && git reset --hard origin/<branch>` on each branch) and not to push old branches
  back — a single `git push` from a stale clone re-introduces the leaked commits. Freeze merges while you do this.
- **GitHub keeps old objects.** After a force-push, old commits remain reachable by hash, in pull request refs
  and in forks. Contact GitHub Support to purge cached views/PR refs, and review **Secret scanning** alerts
  (Security tab) — enable **push protection** so the next `git push` with a key is blocked before it lands.
- Use a fresh mirror for the real thing: `git clone --mirror <url> && cd repo.git && git filter-repo ... &&
  git push --force --mirror`. Then no `--force` is needed and your working copy stays untouched until you re-clone.
- `git filter-repo --replace-text expressions.txt` (lines like `pfx_live_9f3c2a7e5b1d4c88a01e==>***REMOVED***`) is the
  alternative when a secret is hard-coded inside a file you need to keep.
- Commit a `.env.example` with dummy values, keep real secrets in a secrets manager, and add a pre-commit
  scanner (gitleaks, trufflehog) — prevention is far cheaper than this exercise.
- Avoid the deprecated `git filter-branch` for this; BFG Repo-Cleaner also works but filter-repo is what the
  Git project recommends.
