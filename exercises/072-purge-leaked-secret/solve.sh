cd repo
git filter-repo --force --quiet --invert-paths --path .env
git remote add origin ../remotes/origin.git
printf '%s\n' ".env" ".env.*" >> .gitignore
git add .gitignore
git commit -q -m "Ignore .env files"
printf 'PAYFLUX_SECRET=%s\nPAYFLUX_ENV=live\n' pfx_live_R0TATED_51b7c2d9e8 > .env
git push -q --force origin --all
git push -q --force origin --tags
git branch -q -u origin/main main
