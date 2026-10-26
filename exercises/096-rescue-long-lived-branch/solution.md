# Solution

**Decision: merge.** The branch is published and Lena has unpushed work on top of it. Rebasing would give all
four commits new hashes; Lena's `git pull` would then try to merge the old and new copies (duplicate commits,
repeated conflicts), and links in PR comments would point at commits that no longer exist on the branch.

```bash
echo merge > ../ANSWER
git switch feature/multi-currency
git fetch origin                         # in real life: be sure you integrate the latest main
git merge main
git status                               # three different conflict types
```

| path | conflict | resolution |
|---|---|---|
| `README.md` | content | keep both `## Multi-currency` and `## Search` |
| `lib/currency.sh` | file location (directory rename) | Git already moved it into `lib/`: `git add lib/currency.sh` |
| `src/money.sh` | modify/delete | main moved **and** rewrote it, so no rename was detected. Port the currency change into `lib/money.sh`, then `git rm src/money.sh` |

```bash
git show :1:src/money.sh                 # base (3 months ago)
git show :2:src/money.sh                 # the branch's version (currency)
cat lib/money.sh                         # main's version (refunds)
$EDITOR lib/money.sh                     # combine: sign, then symbol, then amount
git rm src/money.sh
./test.sh                                # FAIL tests/test_currency.sh: it still sources ./src/
sed 's#\./src/#./lib/#' tests/test_currency.sh > t && mv t tests/test_currency.sh
./test.sh                                # all ok
git add -A && git commit                 # the merge commit

git switch main
git merge --no-ff feature/multi-currency # land it; first parent = main's previous tip
git push origin main feature/multi-currency
```

**Why it works:** merging `main` into the branch adds one new commit and rewrites nothing, so Lena simply pulls
it. Merge resolution happens once, for the *final* state of both sides — a rebase would replay four
three-month-old commits one by one onto a moved-and-rewritten `money.sh`, resolving conflicts up to four
times. Landing with `--no-ff` keeps `main`'s first-parent chain as "one entry per landed change"; a
fast-forward here would make the feature branch's commits main's first-parent history (see exercise 097).

**Real-world notes**
- **Semantic conflicts are the dangerous ones.** Git merged `tests/test_currency.sh` without complaint, yet
  the result was broken. Never commit a big merge without running the tests — the merge commit is a commit you
  author and must stand behind.
- **When rebase is right:** a private branch, or a shared one when every collaborator agrees, has pushed
  everything, and will `git pull --rebase` / reset afterwards. For a 3-month branch, rebase also makes you
  resolve the same conflict per commit — `git rerere` helps if you go that way.
- **Want a linear history anyway?** Merge `main` into the branch to integrate (safe), then land with
  **Squash and merge** on GitHub — `main` gets one clean commit, the branch keeps its real history.
- **The lead lesson is upstream of Git:** branches that live for months are a planning smell. Ship behind a
  feature flag in small PRs, or at least merge `main` into long branches weekly so conflicts stay small.
  Raise "this branch is drifting" in stand-up long before the PM promises a date.
- Tools: `git log --oneline --left-right --graph main...feature` to size the divergence up front,
  `git merge-tree --write-tree main feature` (Git 2.38+) to preview conflicts without touching the work tree.
