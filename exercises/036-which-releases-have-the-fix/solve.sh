cd repo
echo v2.0.2 > ../ANSWER
git switch -q release/2.x
for h in $(git cherry -v release/2.x main | awk '$1=="+" && $3=="fix:" {print $2}'); do
  git cherry-pick -x "$h" >/dev/null
done
git tag -a v2.0.3 -m "2.0.3"
