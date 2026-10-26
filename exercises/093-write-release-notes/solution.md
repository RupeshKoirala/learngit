# Solution

```bash
r=v1.4.0..v1.5.0
git log --oneline --graph $r                     # look first: PR merges, chores, one body footer
strip() { sed -E 's/^[a-z]+(\([^)]*\))?!?: /- /'; }

{
  echo "## v1.5.0"; echo
  echo "### Features"
  git log --no-merges --format=%s $r -E --grep '^feat(\(|!|:)' | strip; echo
  echo "### Fixes"
  git log --no-merges --format=%s $r -E --grep '^fix(\(|!|:)'  | strip; echo
  echo "### Breaking changes"
  git log --no-merges --format=%s $r -E --grep '^[a-z]+(\([^)]*\))?!:' --grep '^BREAKING CHANGE:' | strip
  echo
} > /tmp/v150.md

{ echo "# Changelog"; echo; cat /tmp/v150.md; tail -n +3 CHANGELOG.md; } > /tmp/cl.md && mv /tmp/cl.md CHANGELOG.md
git diff                                          # read it like Sam will
git commit -am "docs: changelog for v1.5.0"
```

Result:

```markdown
## v1.5.0

### Features
- remove v1 price endpoint
- share wishlist by link
- search API returns paginated results
- save cart between visits

### Fixes
- coupon field accepts lowercase codes
- never double-charge on payment retry
- round half-cent amounts correctly

### Breaking changes
- remove v1 price endpoint
- search API returns paginated results
```

**Why it works:** `v1.4.0..v1.5.0` is "commits reachable from v1.5.0 but not from v1.4.0" — including the
commits inside merged PR branches, which is what you want (the feature commits live there). `--no-merges`
removes the "Merge pull request" noise, and the commit after the tag is excluded because the range ends at
`v1.5.0`. `--grep` matches *any line* of the message (subject or body), which is how the `BREAKING CHANGE:`
footer is found even though the subject looks like an ordinary `feat`. Several `--grep`s are OR-ed (add
`--all-match` to AND them).

**Real-world notes**
- **The footer trap.** Teams that only scan subjects miss `BREAKING CHANGE:` footers — and customers find out
  in production. Always search bodies (`--grep`, or `--format=%B`).
- **Squash-merge teams** only have one commit per PR on `main`; then the PR title *is* the commit subject, so
  enforce Conventional Commit PR titles with a CI check (e.g. a "semantic PR title" action).
- **Automate it.** Tools like *release-please*, *semantic-release*, *git-cliff* or GitHub's
  `gh release create v1.5.0 --generate-notes` do exactly this from tags and commit messages. Knowing the
  underlying `git log` range logic is what lets you debug them when a commit "goes missing".
- **Write for the reader.** Generated notes are a first draft. A PM-aware engineer rewrites the breaking-change
  bullets as *actions* ("Clients must call /api/v2/price") and links PRs/issues. Keep a human-edited
  `## Unreleased` section if your team prefers curated notes over generated ones.
- `--first-parent` + `--merges` gives one line per PR on a merge-commit workflow — but only if nobody broke the
  first-parent chain (exercise 097).
