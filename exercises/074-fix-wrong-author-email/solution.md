# Solution

```bash
cd repo
git config user.email                                  # night.owl.coder@mail.example  <- the cause
git config user.email you@brightcart.example           # repo-level (stored in .git/config)

git log --format='%h %ae %ce %s' origin/main..HEAD     # 5 commits to fix, none pushed
git rebase -x 'git commit --amend --no-edit --reset-author' origin/main
git log --format='%h %ae %ce %s' origin/main..HEAD     # all you@brightcart.example

printf 'Your Name <you@brightcart.example> <night.owl.coder@mail.example>\n' > .mailmap
git check-mailmap "x <night.owl.coder@mail.example>"   # Your Name <you@brightcart.example>
git shortlog -sne                                      # one line for you, not two
git add .mailmap && git commit -m "Add .mailmap for my old personal-email commits"
```

**Why it works:** every commit stores two identities. The **author** wrote the change; the **committer** last
created that commit object (a rebase, amend or cherry-pick makes *you* the committer). A plain rebase would
fix the committer but keep the old author, because rebase preserves authorship. `--reset-author` tells
`commit --amend` to take the author from the current config too, and `-x` runs that amend after each replayed
commit. The hashes change, which is fine: nobody has these commits yet.

The two pushed commits are a different story — rewriting `main` would break every teammate's clone for a
cosmetic fix. `.mailmap` is Git's official "display alias" file: `git log` (with `log.mailmap`, the default since
Git 2.41), `shortlog`, `blame` and `check-mailmap` read it and show the canonical identity, without touching any hash.

**Real-world notes**
- Prevent it for good with conditional includes in `~/.gitconfig`:
  ```ini
  [includeIf "gitdir:~/work/"]
      path = ~/.gitconfig-work      # contains [user] email = you@brightcart.example
  ```
  and `git config --global user.useConfigOnly true` + no global email, so Git refuses to commit until a repo
  has an identity.
- Already pushed to *your own* feature branch? Same rebase, then `git push --force-with-lease`.
- `--reset-author` also resets the **author date** to now. To keep the original dates, use
  `git rebase -x 'git commit --amend --no-edit --author="Name <you@brightcart.example>"'` (that keeps the author
  date) — the committer email comes from your fixed config either way.
- GitHub attributes commits to accounts by email: add your work email to your GitHub account (or use your
  `ID+user@users.noreply.github.com` address) so contributions are linked. Mailmap does not affect GitHub's UI.
- Rewriting authorship of a whole shared repo (`git filter-repo --mailmap`) is possible, but it's a
  history rewrite with all the coordination cost of exercise 072. Reserve it for repo migrations.
