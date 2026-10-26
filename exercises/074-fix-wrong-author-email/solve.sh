cd repo
# setup.sh's helpers export GIT_AUTHOR_*/GIT_COMMITTER_* (env beats config) — a real shell has none of them
unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
git config user.email you@brightcart.example
git rebase -q -x 'git commit -q --amend --no-edit --reset-author' origin/main
printf '%s <%s> <%s>\n' "$(git config user.name)" you@brightcart.example night.owl.coder@mail.example > .mailmap
git add .mailmap
git commit -q -m "Add .mailmap for my old personal-email commits"
