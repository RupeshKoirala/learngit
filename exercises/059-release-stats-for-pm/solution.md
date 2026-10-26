# Solution

```bash
git shortlog -sne v2.0..v2.1
#     13  Lena Okafor <lena@brightcart.example>
#      9  Dev P. <dev.patel@home.example>          <- same person...
#      9  Dev Patel <dev@brightcart.example>       <- ...counted twice
#      9  Maya Chen <maya@brightcart.example>
#      8  Jo Novak <jo@brightcart.example>

echo 'Dev Patel <dev@brightcart.example> <dev.patel@home.example>' > .mailmap
git check-mailmap "Dev P. <dev.patel@home.example>"   # Dev Patel <dev@brightcart.example>
git add .mailmap && git commit -m "Add .mailmap: merge Dev's two identities"

git shortlog -sne v2.0..v2.1
#     18  Dev Patel <dev@brightcart.example>       <- the real top contributor
#     13  Lena Okafor ...

git rev-list --count v2.0..v2.1                         # 48
git rev-list --count --since=2025-03-01 v2.0..v2.1      # 18
git log --format= --name-only v2.0..v2.1 | sort | uniq -c | sort -rn | head -3
#     24 src/checkout.js
#     10 src/styles.css
#     10 src/price.js
```

`../ANSWER`:
```
top=Dev Patel
commits=48
since=18
hotfile=src/checkout.js
```

**Why it works**
- `v2.0..v2.1` is exactly "what's new in 2.1": everything reachable from the v2.1 tag minus everything
  already in v2.0. Commits after the tag aren't reachable from it, so they don't count.
- `.mailmap` is read by `shortlog`, `log` (with `%aN`/`%aE` or `--use-mailmap`, the default since git 2.23),
  `blame` and `check-mailmap`. It rewrites identities *for display only*: history stays the same, so it's
  safe to add at any time.
- `--since`/`--until` filter by **committer date** and stop walking once commits get too old, assuming
  dates are roughly in order. For exact cut-offs on messy histories, prefer ranges between tags.
- `--format=` (empty) with `--name-only` prints only file paths, one per line per commit. `uniq -c` turns that
  into "number of commits that touched each file".

**Real-world notes**
- **Fix identities at the source too.** Ask Dev to set `git config --global user.email dev@brightcart.example`,
  or use `includeIf "gitdir:~/work/"` to switch identities per folder. `.mailmap` repairs the past,
  config prevents the future. On GitHub, adding the email to your account makes commits link to your profile.
- **Careful with commit counts as a metric.** 18 tiny commits vs 5 big ones says nothing about impact. Give
  a PM context ("Dev led checkout hardening") rather than a leaderboard. Commit counts are fine for
  *thank-yous*, terrible for performance reviews.
- **Hot spots** (files changed most often) are useful: they're where bugs cluster and where tests and
  refactoring pay off most. Combine with `git log --since=6.months --format= --name-only` for a trend.
- More release-report one-liners:
  - `git log --oneline --no-merges v2.0..v2.1`: changelog draft,
  - `git diff --stat v2.0 v2.1 | tail -1`: "N files changed, X insertions, Y deletions",
  - `git log --merges --first-parent --oneline v2.0..v2.1`: one line per merged PR.
- `git shortlog -sn --group=trailer:co-authored-by` credits pair-programming co-authors (git ≥ 2.29).
