cd repo
git fetch -q origin pull/42/head:pr-42
git switch -q pr-42
./test.sh >/dev/null || true
printf '%s\n' "request changes" "src/shipping.js: spec says 50.00 or more ships free; code uses > instead of >=." > ../ANSWER
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git fetch -q
git switch -q main
