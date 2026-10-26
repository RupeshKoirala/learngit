cd repo
{
  echo "q1=$(git rev-list --count main..origin/main)"
  echo "q2=$(git rev-list --count origin/main..main)"
  echo "q3=$(git rev-list --count main...origin/main)"
  echo "q4=$(git rev-list --count --first-parent main..feature/gift-cards)"
  echo "q5=$(git rev-list --count origin/release/1.3 ^main ^origin/main)"
} > ../ANSWER
git tag needs-port "$(git log --format='%H %s' --cherry-pick --right-only origin/main...origin/release/1.3 | grep -v 'Bump version' | head -1 | cut -d' ' -f1)"
