cd repo
git switch -q -c hotfix/2.0.1 v2.0.0
replace src/shipping.js "totalCents > FREE" "totalCents >= FREE"
commit "fix(shipping): free shipping from exactly \$50"
fix=$(git rev-parse HEAD)
write VERSION "2.0.1"
commit "chore(release): 2.0.1"
./test.sh >/dev/null
git tag -a v2.0.1 -m "Brightcart 2.0.1"
git switch -q main
git cherry-pick -x "$fix" >/dev/null
git push -q origin main hotfix/2.0.1 v2.0.1
