Find each package's latest tag: `git describe --abbrev=0 --match 'sdk-v*' main` (or `git tag -l 'sdk-v*' --sort=-v:refname`).
Then list what changed **for that package only**:
`git log --oneline sdk-v2.3.1..main -- packages/sdk`. Without the `-- packages/sdk` part you'd count other packages' commits.
---
Subjects aren't enough — a breaking change can be declared in the body. Look at full messages:
`git log --format='%h %s%n%b' sdk-v2.3.1..main -- packages/sdk`, or search directly:
`git log --oneline --grep '^BREAKING CHANGE' sdk-v2.3.1..main -- packages/sdk`.
---
Decisions: **sdk** has a `BREAKING CHANGE:` footer → major → `3.0.0`. **widgets** is pre-1.0 and has a `!` →
minor → `0.5.0`. **cli** only has a fix (plus docs/chore) → patch → `1.2.1` — the `feat(sdk)` commit isn't
cli's business.
---
`git tag -a sdk-v3.0.0 -m "sdk 3.0.0" main` (same for the other two), then
`git describe --match 'sdk-v*' feature/retry-backoff > ../ANSWER`. It looks like `sdk-v3.0.0-2-g1a2b3c4`:
tag, commits since the tag, `g` + abbreviated hash.
