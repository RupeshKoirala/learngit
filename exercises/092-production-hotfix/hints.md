`git switch -c hotfix/2.0.1 v2.0.0` puts you on exactly what's in production. `git log --oneline v2.0.0..main`
shows everything you must *not* ship.
---
Commit the fix on its own (`fix(shipping): free shipping from exactly $50`), then bump `VERSION` in a second
commit (`chore(release): 2.0.1`). Keeping them apart makes the forward-port easy: you'll only carry the fix
to `main`, not the version bump. Then `git tag -a v2.0.1 -m "Brightcart 2.0.1"` and
`git diff --stat v2.0.0 v2.0.1` — it should list two files.
---
Forward-port: `git switch main && git cherry-pick -x <fix-hash>`. Cherry-pick does a 3-way merge, so it applies
even though `main` has changed other lines in `src/shipping.js` since 2.0.0. The `-x` adds
"(cherry picked from commit …)" so anyone can trace the fix later.
---
If you chose `git merge hotfix/2.0.1` instead, `VERSION` conflicts (2.0.1 vs 2.1.0-dev). Keep `main`'s
version: `git checkout --ours VERSION && git add VERSION && git commit`. Finally
`git push origin main hotfix/2.0.1 v2.0.1`.
