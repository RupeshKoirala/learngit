cd repo
git remote add upstream ../remotes/brightcart.git
git fetch -q upstream
git switch -q main
git merge -q --ff-only upstream/main
git push -q origin main
git switch -q feature/size-guide
git rebase -q upstream/main
git push -q --force-with-lease
