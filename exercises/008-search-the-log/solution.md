# Solution

```bash
git log --format='%h %ad %<(12,trunc)%an %s' --date=short     # overview

git log --author=Lena --reverse --oneline | head -1          # Style the cart page
git log --since=2025-03-01 --until=2025-03-07 --oneline      # Guard against empty cart in checkout
git log --grep='#42' --oneline                               # Handle edge case in checkout ("Closes #42" is in the body)
git log --diff-filter=A --oneline -- src/tax.js              # Refactor pricing helpers
git log -S FREESHIP50 --oneline                              # 2 hits: "Clean up promo codes" (removed) and
                                                             #         "Tweak promo config" (added) — the older one
git log -S FREESHIP50 -p --reverse | less                    # confirm: + line in the older commit

git tag lena-first     <hash>
git tag march-hotfix   <hash>
git tag issue-42       <hash>
git tag tax-file       <hash>
git tag freeship-added <hash>
git log --oneline --decorate
```

**Why it works:**
- `--author` / `--committer` are regexes on "Name <email>", so `--author=lena@` or `--author=Okafor` work too.
- `--since` / `--until` (aliases `--after` / `--before`) filter by **committer date**. Dates without a time
  are interpreted in *your* time zone — for exact boundaries add a time, e.g. `2025-03-01T00:00Z`.
- `--grep` matches anywhere in the message; combine several with `--all-match`, add `-i` for case-insensitive.
  Decoys like `Fix #24…` and `Bump version to 1.42` are why a precise pattern (`'#42'`) matters.
- `-- <path>` limits history to commits touching that path; `--diff-filter=A` keeps only commits that
  **added** it (also `D` deleted, `R` renamed, `M` modified).
- `-S<string>` (pickaxe) finds commits where the string's **count** changed — introductions and removals.
  `-G<regex>` finds commits whose diff has a matching added/removed line, even if the count didn't change.
  Neither looks at messages — great when the message is useless ("Tweak promo config", twice!).

**Real-world notes**
- This is daily work for leads: "when did this config value appear?" (`-S`), "what did the contractor change
  last sprint?" (`--author --since`), "which commits went in for ticket X?" (`--grep`). Teams that put issue
  keys in messages (`Closes #42`, `JIRA-123`) make this trivial — one more reason for trailers (exercise 010).
- For "who last changed this *line*", `git blame -L 10,20 file` is faster, and
  `git log -L :functionName:file` follows a function's whole history.
- Use `git shortlog -sn --since=...` for "who contributed how much" — but never as a performance metric.
- Lightweight tags like these are fine for bookmarks; release tags should be annotated (`git tag -a v1.2`).
