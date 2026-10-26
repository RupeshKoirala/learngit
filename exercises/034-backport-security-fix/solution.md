# Solution

```bash
fix=$(git log --format=%H --grep=SEC-112 main)
git show --stat $fix                    # src/html.js (new) + src/search.js

# 1.4 — applies cleanly
git switch release/1.4
git cherry-pick -x $fix
git log -1                              # ... (cherry picked from commit 9f8e7d6...)
git tag -a v1.4.1 -m "1.4.1: SEC-112 XSS in search results"

# 1.3 — conflicts
git switch release/1.3
git cherry-pick -x $fix
```

The conflict in `src/search.js`:

```
<<<<<<< HEAD
  return '<li class="result">' + product.title + '</li>';
=======
  return '<li class="result">' + escapeHtml(product.name) + '</li>';
>>>>>>> 9f8e7d6 (Escape product names in search results (SEC-112))
```

Apply the fix's *intent* to the 1.3 code — escape, but keep 1.3's field name:

```js
  return '<li class="result">' + escapeHtml(product.title) + '</li>';
```

```bash
git add src/search.js
git cherry-pick --continue              # message still carries the -x line
git tag -a v1.3.3 -m "1.3.3: SEC-112 XSS in search results"
```

**Why it works:** `-x` writes the original commit's full hash into the copy's message. The copy has a
different hash (different parent, and on 1.3 a different diff), so without the trailer nothing links
`v1.3.3` to the fix on `main`. With it, `git log --grep "cherry picked from commit $fix" --all` finds every
backport in one command — exactly what an auditor or the next on-call engineer needs.

Copying `product.name` into 1.3 would have "resolved" the conflict and shipped a release that renders
`undefined` for every result. Backport conflicts are where regressions sneak into old branches.

**Real-world notes**
- **Fix forward, then backport, newest to oldest.** The fix is reviewed on `main`; each older line is a
  smaller step from the previous one, and you resolve conflicts incrementally.
- Each backport should still go through **CI and a PR** targeting the release branch
  (`git switch -c backport/sec-112-1.3 release/1.3`, pick, push, PR). The conflict-resolved one deserves a
  real review — it's *new code* nobody has looked at yet.
- Use `-x` for backports to public/long-lived branches. Don't use it when picking your *own* unpublished
  commits around (the referenced hash would point at something nobody else can see).
- For security fixes, coordinate timing: tag and ship all supported lines **together**, then disclose.
  A fix visible on `main` while 1.3 is still unpatched tells attackers exactly where to look.
- Annotated tags (`-a`) carry author, date and message — use them for releases; lightweight tags are fine
  for personal bookmarks.
