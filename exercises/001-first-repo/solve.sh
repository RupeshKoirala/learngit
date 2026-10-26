cd shop
git init -q -b main
git config user.name  "$LG_LEARNER_NAME"
git config user.email "$LG_LEARNER_EMAIL"
printf '%s\n' "# dependencies" "node_modules/" "" "# secrets" ".env" "" "# logs" "*.log" > .gitignore
git add .gitignore
git commit -q -m "Add .gitignore"
git add .
git commit -q -m "Add storefront prototype"
