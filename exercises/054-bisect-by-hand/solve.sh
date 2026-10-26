cd repo
git bisect start main v1.4 >/dev/null
# play the human: read the mock-up, answer good/bad until Git names the culprit (max 10 rounds)
n=0
while ! git bisect log | grep -q '^# first bad commit' && [ "$n" -lt 10 ]; do
  if grep -q '|  \[ Place order \]' ui/checkout.txt; then git bisect bad >/dev/null; else git bisect good >/dev/null; fi
  n=$((n + 1))
done
git tag first-bad refs/bisect/bad
git bisect reset >/dev/null 2>&1
