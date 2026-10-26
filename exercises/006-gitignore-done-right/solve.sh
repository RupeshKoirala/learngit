cd repo
git check-ignore -v assets/logo.png | cut -d: -f1 > ../ANSWER
printf '%s\n' "# dependencies" "node_modules/" "" "# secrets (keep the template)" ".env" ".env.*" "!.env.example" \
  "" "# logs (keep the folder)" "*.log" "logs/*" "!logs/.gitkeep" "" "*.tmp" > .gitignore
printf '%s\n' "" "# the official logo is source, not an export" "!logo.png" >> assets/.gitignore
git rm -r -q --cached node_modules .env .env.local logs/app.log
git add .gitignore assets/
git commit -q -m "Stop tracking dependencies, secrets and logs"
