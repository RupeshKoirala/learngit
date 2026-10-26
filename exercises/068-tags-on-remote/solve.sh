cd repo
git tag -a v2.4.0 -m "Brightcart 2.4.0" main
git push -q origin v2.4.0
bump=$(git log --format='%H %s' main | awk '$2=="Bump" && $5=="2.3.1" {print $1}')
git push -q origin --delete v2.3.1
git tag -f -a v2.3.1 -m "Brightcart 2.3.1" "$bump" >/dev/null
git push -q origin v2.3.1
cd ../.team/dev
if git fetch -q --tags 2>/dev/null; then echo "fetch should have refused to clobber the tag" >&2; exit 1; fi
git fetch -q --tags --force
