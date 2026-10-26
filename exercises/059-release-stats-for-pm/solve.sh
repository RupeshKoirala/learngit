cd repo
echo 'Dev Patel <dev@brightcart.example> <dev.patel@home.example>' > .mailmap
git add .mailmap
commit "Add .mailmap: merge Dev's two identities"
{
  echo "top=$(git shortlog -sn v2.0..v2.1 | head -1 | cut -f2)"
  echo "commits=$(git rev-list --count v2.0..v2.1)"
  echo "since=$(git rev-list --count --since=2025-03-01 v2.0..v2.1)"
  echo "hotfile=$(git log --format= --name-only v2.0..v2.1 | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"
} > ../ANSWER
