# Solution

```bash
git shortlog -sn HEAD -- src/checkout/     # 6 Dev Patel, 1 Lena Okafor, 1 Maya Chen
git shortlog -sn HEAD -- src/catalog/      # 5 Lena Okafor, 4 Dev Patel   (.mailmap merges lena-o)
git shortlog -sn HEAD -- src/search/       # 3 Jo Novak, 1 Dev Patel, 1 Maya Chen
git log --format=%an -- src/catalog/ | sort | uniq -c | sort -rn
#   4 Dev Patel  3 Lena Okafor  2 lena-o    <- without the mailmap you'd pick the wrong expert
```

`.github/CODEOWNERS`:

```
# Last matching pattern wins. Keep general rules first, specific rules last.
*                         @brightcart/maintainers

/src/checkout/            @devpatel
/src/catalog/             @lenaokafor
/src/search/              @jonovak
/src/checkout/payments/   @devpatel @brightcart/security

/infra/                   @brightcart/platform
/.github/workflows/       @brightcart/platform
/docs/                    @samrivera

*.sql                     @brightcart/dba
/.github/CODEOWNERS       @mayachen
```

```bash
git add .github/CODEOWNERS && git commit -m "chore: add CODEOWNERS"
```

**Why it works:** for each file in a PR, GitHub takes the **last** line whose pattern matches and requests
exactly those owners — earlier matches are ignored, not merged. So `*` goes first as the fallback,
`/src/checkout/payments/` must come after `/src/checkout/` (and repeats `@devpatel`, because owners don't
inherit), and `*.sql` must come after the folder rules or `src/checkout/queries.sql` would go to Dev only.
Patterns follow `.gitignore` rules: a leading `/` anchors at the repo root, a trailing `/` means "everything
in this directory", and a pattern without a slash (`*.sql`) matches at any depth.

`git shortlog` groups commits by author and applies `.mailmap`; `-s` gives counts, `-n` sorts by count,
`-e` shows emails (great for spotting split identities), and a `-- <path>` limits it to a folder.

**Real-world notes**
- **Commit count ≠ expertise.** It's a good first signal; also look at *recent* activity
  (`--since=6.months`), lines touched (`git log --numstat`), and who reviews PRs there. Then **ask the
  people** — CODEOWNERS is a social contract, not a statistic. Jo being the search expert may surprise Dev.
- **Prefer teams over individuals.** `@brightcart/search` survives vacations and people leaving; a single
  person as required reviewer becomes a bottleneck and a bus factor of one. Individuals are fine as
  *suggested* reviewers.
- **Turn it on:** branch protection / rulesets → "Require review from Code Owners". Without that, CODEOWNERS
  only *requests* reviews. Owners need write access, or GitHub ignores the line (it flags errors on the file's
  page in the UI).
- **Own the ownership file:** making `.github/CODEOWNERS` owned by the lead stops anyone from quietly
  removing themselves as reviewer of, say, payments.
- **Fix the data:** commit a `.mailmap` whenever someone commits under a second identity; `shortlog`,
  `blame` and `log --format=%aN` all become correct retroactively without rewriting history.
- Gotchas: no `!` negation, no `[a-z]` ranges in CODEOWNERS; a line with a pattern but no owners means
  "nobody owns this" (useful to carve an exception out of a broader rule).
