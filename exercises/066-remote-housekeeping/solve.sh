cd repo
git fetch -q --prune
git branch -q -d feature/gift-cards
git push -q origin --delete spike/old-checkout
git branch -m master main
git push -q -u origin main
git --git-dir=../remotes/origin.git symbolic-ref HEAD refs/heads/main
git push -q origin --delete master
git fetch -q --prune
git remote set-head origin --auto >/dev/null
