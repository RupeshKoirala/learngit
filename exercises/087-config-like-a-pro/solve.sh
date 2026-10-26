export GIT_CONFIG_GLOBAL=/dev/null
unset GIT_AUTHOR_EMAIL GIT_COMMITTER_EMAIL GIT_AUTHOR_NAME GIT_COMMITTER_NAME
cd work/storefront
git config --file ../../gitconfig alias.lg "log --graph --oneline --decorate --all"
git config --file ../../gitconfig alias.undo "reset --soft HEAD~1"
git config --file ../../gitconfig-work user.email you@brightcart.example
git config --file ../../gitconfig includeIf.gitdir:./work/.path gitconfig-work
git config --show-origin --show-scope --get-all pull.rebase >/dev/null
git config --local --unset pull.rebase
git commit -q --amend --no-edit --reset-author
