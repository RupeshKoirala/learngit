git clone -q remotes/origin.git fresh
cd repo
git fetch -q
git rev-list --count main..origin/main > ../ANSWER
git merge -q --ff-only origin/main
git switch -q feature/gift-cards
git switch -q main
