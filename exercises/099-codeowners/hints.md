Find the experts per folder: `git shortlog -sn -- src/checkout/` (and `src/catalog/`, `src/search/`).
(In a script or pipe, write `git shortlog -sn HEAD -- …` — without a revision, shortlog reads a log from stdin.)
`shortlog` applies `.mailmap`, so Lena's two identities are counted as one person. Compare with
`git log --format=%an -- src/catalog/ | sort | uniq -c` — `%an` ignores the mailmap and gives a different winner!
(`%aN` respects it.)
---
The creator of a folder isn't automatically its expert: `src/search/` was imported by Dev in one big commit,
but someone else has worked on it far more since.
---
Order lines from general to specific, because the last match wins: the `*` default first, then folders,
then `src/checkout/payments/` (after `/src/checkout/`), then `*.sql` (after every folder rule, so it beats
`/src/checkout/`), and `/.github/CODEOWNERS` at the end.
---
The experts are: checkout → `@devpatel`, catalog → `@lenaokafor` (5 commits once merged via `.mailmap`, vs Dev's 4),
search → `@jonovak`. A line looks like `/src/checkout/payments/  @devpatel @brightcart/security`.
Then `git add .github/CODEOWNERS && git commit -m "chore: add CODEOWNERS"`.
