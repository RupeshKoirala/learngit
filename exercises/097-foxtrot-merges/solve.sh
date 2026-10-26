cd repo
fox=$(git log --merges --format='%H %s' origin/main | awk '/Merge branch .main. of/ {print $1; exit}')
echo "$fox" > ../ANSWER
git rebase -q origin/main
git push -q origin main
git config pull.rebase true
