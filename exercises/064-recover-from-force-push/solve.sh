cd repo
git cherry-pick HEAD..release/2.4@{1} >/dev/null
git push -q
git --git-dir=../remotes/origin.git config receive.denyNonFastForwards true
