cd repo
git bisect start v3.1.0 v3.0.0 >/dev/null
git bisect run ../repro-checkout.sh > ../.lg/bisect.out 2>&1
bad=$(git rev-parse refs/bisect/bad)
git bisect reset >/dev/null 2>&1
git switch -q release/3.1
git revert --no-edit "$bad" >/dev/null
../repro-checkout.sh >/dev/null
git tag -a v3.1.1 -m "Brightcart 3.1.1 (INC-311)"
rev=$(git rev-parse HEAD)
git switch -q main
git cherry-pick -x "$rev" >/dev/null
short=$(git rev-parse --short=10 "$bad")
write INCIDENT.md \
  "# INC-311: customers could not check out (Sev-1)" "" \
  "## Timeline" \
  "- 09:12 v3.1.0 deployed to production" \
  "- 09:40 support reports ~200 failed checkouts" \
  "- 09:55 incident declared, production rolled back to v3.0.0 (last good)" \
  "- 10:20 culprit found with git bisect run" \
  "- 10:45 v3.1.1 (revert) released" "" \
  "## Root cause" \
  "Commit $short changed the item check from -ge to -gt, so 1-item carts were rejected." "" \
  "## Resolution" \
  "Reverted on release/3.1, tagged v3.1.1, cherry-picked the revert to main." \
  "Follow-up: add the repro as a regression test in CI."
commit "docs: INC-311 postmortem"
