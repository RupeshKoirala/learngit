cd repo
git rebase -q -x 'git rm -r -q --cached --ignore-unmatch node_modules dist && git commit -q --amend --no-edit --allow-empty' main
printf '%s\n' "node_modules/" "dist/" >> .gitignore
git add .gitignore
git commit -q -m "Ignore node_modules/ and dist/"
