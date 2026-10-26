cd repo
git remote add backup ../remotes/backup.git
git push -q origin main
git push -q backup main
git remote set-url gitlab ../remotes/legacy.git
git remote rename gitlab legacy
git fetch -q legacy
git remote remove heroku
