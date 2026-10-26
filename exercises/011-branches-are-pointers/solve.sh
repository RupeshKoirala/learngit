cd repo
git branch hotfix/1.0.1 v1.0
git branch experiment/shipping-rules "$(git log --format=%h --grep='^Add free-shipping threshold$' main)"
git branch -m fixtypo fix/readme-typo
git switch -q -c feature/wishlist main
behind=$(git branch -vv | sed -n 's/^[* ] *\([^ ]*\) .*: behind [0-9]*\].*/\1/p')
echo "$behind" > ../ANSWER
