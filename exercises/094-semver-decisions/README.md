# Semantic versioning: pick the next version and name the build

Brightcart's monorepo ships three packages, each with its own tags (`<package>-vX.Y.Z`). It's release day and
Maya asked you to decide the next version of every package — customers pin these versions, so a wrong number
either breaks their builds or hides a fix from them.

```
* chore(cli): bump yargs                       <- main (release this commit)
* fix(widgets): mini cart overflow on mobile
* refactor(sdk): simplify connection handling
* docs(cli): usage examples
* feat(sdk): add listOrders()
* fix(cli): friendly error when config is missing
* feat(widgets)!: rename Price prop 'amount' to 'cents'
* fix(sdk): retry once on HTTP 503
* fix(sdk): honour request timeout             (sdk-v2.3.1)
* ...                                          (widgets-v0.4.2, cli-v1.2.0, older tags)
```

**Team versioning policy** (Semantic Versioning + Conventional Commits):
- Only commits that touch `packages/<name>/` count for that package.
- **1.0 and above:** any breaking change → **major**; otherwise any `feat` → **minor**; otherwise any `fix` →
  **patch**. A breaking change is a `!` after the type/scope *or* a `BREAKING CHANGE:` footer in the body.
- **Below 1.0** (like npm's and Cargo's `^0.x` ranges): a breaking change bumps the **minor**; anything else
  releasable bumps the **patch**.

## Your task

1. For each package (`sdk`, `widgets`, `cli`) find the commits since its latest tag and decide the next version.
2. Create one **annotated** tag per package on the tip of `main`, e.g. `sdk-vX.Y.Z`. Create no other tags.
3. CI names every build with `git describe --match 'sdk-v*'`. Dev's branch `feature/retry-backoff` is 2 commits
   ahead of `main`. Once your tags exist, write the build name `git describe` gives for that branch's tip into
   the file `ANSWER` (in the sandbox folder, next to `repo/`).

## You'll practice

`git describe` (to find the last tag *and* to name builds), `git tag -l 'pattern'`, path-limited logs
(`git log sdk-v2.3.1..main -- packages/sdk`), searching commit bodies, and the SemVer rules — including the
pre-1.0 rule nobody remembers.
