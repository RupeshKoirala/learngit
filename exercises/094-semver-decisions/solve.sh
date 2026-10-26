cd repo
for p in sdk widgets cli; do
  last=$(git describe --abbrev=0 --match "$p-v*" main)
  git log --format='%s%n%b' "$last..main" -- "packages/$p" > /dev/null
done
git tag -a sdk-v3.0.0     -m "sdk 3.0.0"     main
git tag -a widgets-v0.5.0 -m "widgets 0.5.0" main
git tag -a cli-v1.2.1     -m "cli 1.2.1"     main
git describe --match 'sdk-v*' feature/retry-backoff > ../ANSWER
