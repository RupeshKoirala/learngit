Server side: `git -C remotes/monorepo.git config uploadpack.allowFilter true`. Without it, the clone prints
`warning: filtering not recognized by server, ignoring` and silently gives you everything.
---
```bash
git clone --filter=blob:none --sparse "file://$PWD/remotes/monorepo.git" slim
```
`--sparse` starts in cone mode with only the files at the root. Messed up? `rm -rf slim` and clone again.
---
```bash
cd slim
git sparse-checkout set --cone services/payments
git sparse-checkout list          # services/payments
ls services                       # only payments
```
Git fetches the missing blobs for `services/payments` on demand, right then.
---
Commits and pushes work as usual in a sparse, partial clone:

```bash
git switch -c fix/payments-timeout
# edit services/payments/retry.js: TIMEOUT_MS = 15000
git commit -am "fix(payments): raise capture timeout to 15s"
git push -u origin fix/payments-timeout
```
Compare `git count-objects -vH` in `slim` and in `repo`.
