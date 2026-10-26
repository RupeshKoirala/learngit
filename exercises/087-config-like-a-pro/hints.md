Aliases are just config keys:

```bash
git config --file ../../gitconfig alias.lg "log --graph --oneline --decorate --all"
git config --file ../../gitconfig alias.undo "reset --soft HEAD~1"
```
Try `git lg`. (In real life: `git config --global alias.lg …`)
---
A conditional include is a section named `includeIf "gitdir:<pattern>"` with a `path`. A pattern ending in `/`
matches everything below it, and a pattern starting with `./` is relative to the config file it's written in.
So in `gitconfig`:

```ini
[includeIf "gitdir:./work/"]
	path = gitconfig-work
```
(In `~/.gitconfig` you'd typically write `gitdir:~/work/`.) Order matters: put it **after** `[user]` so it wins.
---
`git config --show-origin --show-scope --get-all pull.rebase` lists every place that sets the key, in the
order Git reads them; the last one wins. Remove the culprit with `git config --local --unset pull.rebase`.
Then `git config --show-origin user.email` should point at `gitconfig-work`.
---
With the right email now active, `git commit --amend --no-edit --reset-author` rewrites the author of the
last commit using your current config. Check with `git log -1 --format='%an <%ae>'`. Then try `git undo`
on a throwaway commit if you like (and recommit).
