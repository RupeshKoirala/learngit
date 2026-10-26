# Solution

```bash
cd repo
git rev-parse --is-shallow-repository      # true
git log --oneline                          # 1 commit, (grafted)
git blame src/shipping.js                  # ^8d1c… (release-bot …) on every line: the boundary commit

git fetch --deepen=5
git log --oneline | wc -l                  # 6
git fetch --unshallow                      # the rest
git rev-parse --is-shallow-repository      # false

git blame -e -L '/FREE_SHIPPING_THRESHOLD/,+1' src/shipping.js   # <dev@brightcart.example>
git log -S FREE_SHIPPING_THRESHOLD --reverse --format='%h %ae %s' # "Free shipping threshold" by Dev
echo dev@brightcart.example > ../ANSWER

cd ..
git clone --filter=blob:none "file://$PWD/remotes/origin.git" partial
git -C partial config remote.origin.partialclonefilter      # blob:none
git -C partial rev-list --count HEAD                        # all commits…
git -C partial rev-list --objects --missing=print --all | grep -c '^?'   # …but most old blobs not downloaded
git -C partial log -p -- data/catalog.csv | head            # blobs are fetched lazily when needed
```

**Why it works:** `--depth N` asks the server for only the last N commits and records the cut in `.git/shallow`.
History-walking commands stop at that boundary — so `blame` attributes everything older to the boundary commit,
`describe` can't find tags, `bisect` has no "good" commit, and `merge-base` with another branch may fail.
`--deepen`/`--depth`/`--unshallow` move the boundary. A **partial clone** (`--filter=blob:none`) instead downloads
all commits and trees but no file contents except what checkout needs; the remote becomes a *promisor* that Git asks
for missing blobs on demand. `log`, `blame`, `bisect` all work — they just fetch blobs as they go.

Local paths (`git clone remotes/origin.git`) use a special copy/hardlink transport that ignores `--depth` and
`--filter`; `file://` forces the real protocol. The server must allow filters (`uploadpack.allowFilter`), which
GitHub, GitLab and Bitbucket do.

**Real-world notes**
- **CI:** `actions/checkout` defaults to `fetch-depth: 1`. Fine for build+test; set `fetch-depth: 0` (or a blobless
  clone) for jobs that need tags (`git describe`, semantic-release), changelogs, blame-based tooling, or
  "diff against main" (`git merge-base` fails on a depth-1 clone).
- **Humans on huge repos:** prefer `--filter=blob:none` over `--depth`: full history, fast clone, everything works.
  `--filter=tree:0` (treeless) is even smaller but slow for history-heavy commands — good for one-off CI builds.
  Combine with `git sparse-checkout` for monorepos.
- Shallow clones push fine in modern Git, but fetching into them is more expensive for the server; don't make
  shallow clones your long-lived dev checkout.
- As a lead, answering "who decided this and why?" needs full history *and* good commit messages — link the
  ticket/decision (e.g. "product decision 2024-11") in the commit, not only in Slack.
