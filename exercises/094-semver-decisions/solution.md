# Solution

```bash
for p in sdk widgets cli; do
  last=$(git describe --abbrev=0 --match "$p-v*" main)
  echo "== $p (last: $last)"
  git log --format='  %h %s%n%w(0,6,6)%b' "$last..main" -- "packages/$p"
done
```

| package | since | commits that count | decision |
|---|---|---|---|
| sdk | `sdk-v2.3.1` | fix (503 retry), feat (`listOrders`), refactor **with `BREAKING CHANGE:` footer** | major → **sdk-v3.0.0** |
| widgets | `widgets-v0.4.2` | `feat(widgets)!` (breaking), fix | pre-1.0 breaking → minor → **widgets-v0.5.0** |
| cli | `cli-v1.2.0` | fix, docs, chore | patch → **cli-v1.2.1** |

```bash
git tag -a sdk-v3.0.0     -m "sdk 3.0.0"     main
git tag -a widgets-v0.5.0 -m "widgets 0.5.0" main
git tag -a cli-v1.2.1     -m "cli 1.2.1"     main
git describe --match 'sdk-v*' feature/retry-backoff > ../ANSWER     # sdk-v3.0.0-2-g<hash>
```

**Why it works:** `git describe --abbrev=0 --match` walks back from a commit to the nearest matching tag — the
"last release" of that package. A `--` pathspec limits the log to commits touching that package, so Dev's
`feat(sdk)` doesn't turn the CLI release into a minor. The SDK's subject lines look like "fix + feat = minor",
but the refactor's footer declares a breaking change, so only reading bodies gives the right answer: 3.0.0.

`git describe` output `sdk-v3.0.0-2-g1a2b3c4` means: nearest tag, 2 commits on top of it, `g` (for git) + the
abbreviated commit hash. It's unique, sortable-ish, and human-readable — perfect for build numbers, Docker
image tags and "what version is running?" pages.

**Real-world notes**
- **Pre-1.0 is not a free-for-all in practice.** SemVer says anything may change in 0.x, but npm/Cargo caret
  ranges (`^0.4.2` = `>=0.4.2 <0.5.0`) treat the minor as the "major". Bumping only the patch for a breaking
  change in 0.x breaks every user with a caret range. Write the rule down, as Brightcart did.
- **`git describe` ignores lightweight tags** unless you pass `--tags`. Another reason releases get annotated
  tags. Add `--dirty` in CI to mark builds from modified trees, and `--always` to fall back to a hash.
- **Monorepos:** one tag namespace per package (`sdk-v…`) plus `--match`, or tools like Changesets /
  release-please in monorepo mode. Never let one package's tag satisfy another package's `describe`.
- **Majors are a product decision.** As a lead, a surprise major is a signal: should the breaking change have
  gone behind a deprecation period (keep `connect()` working, warn, remove in the next major)? Raise it with
  the PM *before* tagging — customers experience the version number, not the diff.
- Tags are pushed explicitly (`git push origin sdk-v3.0.0 …`) and must never be moved once public.
