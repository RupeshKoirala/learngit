Try the obvious first: `git tag --contains <hash-of-the-tax-fix-on-main>`. It says `v3.0.0` — because
2.x never got *that commit*, only a copy. You need a tool that compares **changes**, not hashes.
---
`git cherry -v release/2.x main` lists `main`'s commits that aren't on `release/2.x`, comparing by patch:
`-` means "an equivalent change is already upstream (on release/2.x)", `+` means "missing".
To see the release side: `git log --oneline --cherry-mark --left-only release/2.x...main` lists the
commits only on `release/2.x` and marks those with an equivalent on `main` with `=` — those are the copies.
---
The tax fix's copy on `release/2.x` was renamed ("Round tax correctly…"), so `git log --grep` on the
subject won't find it, and it has no `cherry picked from` line either. Once you know the copy, ask
`git tag --contains <copy>` and take the oldest tag. Among the `+` lines from `git cherry`, only one is a
`fix:` commit.
---
```bash
git cherry -v release/2.x main | grep '^+ .* fix:'
git switch release/2.x
git cherry-pick -x <that-hash>
git tag -a v2.0.3 -m "2.0.3"
git log --oneline --cherry-pick --right-only release/2.x...main   # no fix: left in the list
```
