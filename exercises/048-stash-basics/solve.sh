cd repo
git stash push -q -u -m "search: half-done ranking"
old=$(git stash list --format='%gd %gs' | grep 'WIP on' | cut -d' ' -f1)
git stash show --name-only "$old" > ../ANSWER
git stash drop -q "$old"
git stash apply -q "$(git stash list --format='%gd %gs' | grep fuzzy | cut -d' ' -f1)"
