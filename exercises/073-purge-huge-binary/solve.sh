cd repo
git filter-repo --force --quiet --path assets/promo-video.mov --invert-paths
git remote add origin ../remotes/origin.git
printf '%s\n' "*.mov" "*.mp4" >> .gitignore
git add .gitignore
git commit -q -m "Ignore video files (use the CDN or Git LFS)"
git push -q --force origin --all
git branch -q -u origin/main main
