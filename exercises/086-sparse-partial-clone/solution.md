# Solution

From the sandbox folder (`cd "$(./lg where)/.."`):

```bash
# 1. server side (GitHub/GitLab already do this)
git -C remotes/monorepo.git config uploadpack.allowFilter true

# 2. blobless + sparse clone (file:// so Git really talks the network protocol)
git clone --filter=blob:none --sparse "file://$PWD/remotes/monorepo.git" slim
cd slim
ls                                    # README.md CODEOWNERS .gitignore -- nothing else yet

# 3. only payments
git sparse-checkout set --cone services/payments
git sparse-checkout list              # services/payments

# 4. normal work
git switch -c fix/payments-timeout
# edit services/payments/retry.js -> TIMEOUT_MS = 15000
git commit -am "fix(payments): raise capture timeout to 15s"
git push -u origin fix/payments-timeout

# see the savings
git count-objects -vH                 # compare with: git -C ../repo count-objects -vH
git rev-list --objects --all --missing=print | grep -c '^?'   # blobs you never downloaded
```

**Why it works:**
- `--filter=blob:none` asks the server to leave out every blob. You still get **all commits and trees**, so
  `git log`, `git blame` structure, branches and merges work offline. The origin becomes a *promisor remote*
  (`remote.origin.promisor=true`): whenever Git needs a missing blob (checkout, `git show`, diff), it fetches
  just that blob on demand. Old versions of `assets/*.bin` are never downloaded unless you look at them.
- `uploadpack.allowFilter` is the server switch. Without it the server ignores the filter (with a warning) and
  you get a full clone. A plain path clone (`git clone remotes/monorepo.git`) takes the "local clone" shortcut
  (copying/hard-linking `.git/objects`) and ignores the filter too, hence `file://`.
- `--sparse` + cone mode: the working tree contains only top-level files plus the directories you list.
  Cone mode works on whole directories, which makes it fast (hash lookups instead of matching gitignore-style
  patterns against every path) — use it, the old pattern mode is effectively legacy.
- Together, the clone only fetches blobs for files inside your cone. Commits still record the **full** tree;
  sparse-checkout only changes what's on disk, so pushes from `slim` are complete, normal commits.

**Real-world notes**
- `git sparse-checkout add services/catalog` widens the cone (fetching those blobs), `git sparse-checkout
  disable` gives you everything back. Nothing is lost either way.
- Other filters: `--filter=tree:0` (treeless: even smaller, but history commands that walk trees trigger many
  fetches — good for CI builds, worse for humans), `--filter=blob:limit=1m` (skip only big files).
- Partial clone is not shallow clone. `--depth 1` cuts history (no `log`, no `blame`, awkward merges);
  partial clone keeps full history and is the recommended choice for developers. CI often uses `--depth 1`.
- Some commands become network calls in a blobless clone (e.g. `git log -p` on old history, `git blame` on a
  file you never checked out). Offline, they fail.
- Big monorepos combine this with `scalar` (ships with Git): `scalar clone` sets up partial clone,
  cone-mode sparse-checkout, background maintenance and the filesystem monitor in one command.
- Large binaries like those images usually belong in **Git LFS** or an artifact store. Partial clone only
  hides the cost from readers; the server still stores every version.
