# Solution

From `work/storefront`:

```bash
# 1. aliases (real life: git config --global alias.lg …)
git config --file ../../gitconfig alias.lg   "log --graph --oneline --decorate --all"
git config --file ../../gitconfig alias.undo "reset --soft HEAD~1"
git lg

# 2. work identity, only under work/
git config --file ../../gitconfig-work user.email you@brightcart.example
git config --file ../../gitconfig includeIf.gitdir:./work/.path gitconfig-work
git config --show-origin user.email          # file:/…/gitconfig-work   you@brightcart.example
git -C ../../oss/dotfiles config user.email  # you@personal.example

# 3. who overrides pull.rebase?
git config --show-origin --show-scope --get-all pull.rebase
# local  file:/…/gitconfig     true
# local  file:.git/config      false     <- last one wins
git config --local --unset pull.rebase

# 4. fix the author of the last commit
git commit --amend --no-edit --reset-author
git log -1 --format='%an <%ae>'
```

The sandbox `gitconfig` now ends with:

```ini
[alias]
	lg = log --graph --oneline --decorate --all
	undo = reset --soft HEAD~1
[includeIf "gitdir:./work/"]
	path = gitconfig-work
```

**Why it works:**
- Git reads config files in order — system, global (`~/.gitconfig` or `$XDG_CONFIG_HOME/git/config`), local
  (`.git/config`), worktree, then `-c` on the command line — and **the last value read wins**. Includes are
  expanded in place, at the position of the `include`/`includeIf` line. That's why the `includeIf` goes after
  `[user]`, and why the stale `pull.rebase = false` (read after the include) beat your `true`.
  `--show-origin` / `--show-scope` turn "why is Git doing this?" into a one-liner.
- `includeIf "gitdir:<pattern>"` matches the path of the repo's `.git` directory. A trailing `/` means
  "everything below"; `./` means "relative to this config file"; `~/` is your home. Other conditions:
  `gitdir/i:` (case-insensitive), `onbranch:release/*`, and `hasconfig:remote.*.url:https://github.com/acme/**`
  (Git 2.36+), which picks identity by *where the repo is hosted* instead of where it sits on disk.
- `--reset-author` re-reads name/email from config (and resets the author date); without it, `--amend` keeps
  the original author.
- `reset --soft HEAD~1` moves the branch back one commit but leaves index and working tree alone, so the undone
  commit's changes are staged, ready to recommit.

**Real-world notes**
- A typical senior `~/.gitconfig` also has: `push.autoSetupRemote = true`, `fetch.prune = true`,
  `rerere.enabled = true`, `rebase.autoStash = true`, `rebase.updateRefs = true`, `merge.conflictStyle =
  zdiff3`, `diff.algorithm = histogram`, `init.defaultBranch = main`, `commit.verbose = true`.
- More aliases people actually use: `amend = commit --amend --no-edit`, `wip = !git add -A && git commit -m
  wip`, `st = status -sb`, `last = log -1 HEAD --stat`. A leading `!` runs a shell command.
- Keep work and personal identities apart with `includeIf` from day one — wrong emails end up in public
  history forever and can break commit-to-account linking or CLA checks. Also set `user.useConfigOnly = true`
  so Git refuses to guess an email from your hostname.
- Your dotfiles (including `~/.gitconfig`) belong in a repo of their own, like `oss/dotfiles` here. Keep
  secrets and work-specific URLs in the included files, not the public one.
- Avoid rewriting authorship on commits others already pulled; amending your own unpushed commit is fine. For
  older commits use `git rebase -i --exec 'git commit --amend --no-edit --reset-author'` or a `.mailmap`
  to fix how names display without rewriting.
