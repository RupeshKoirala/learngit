# Solution

```bash
git diff v1.2.0 -- src/price.js                   # what changed in that file since the release
git restore --source=v1.2.0 -- src/price.js       # copy just that file from the tag
#   older spelling (also stages it):  git checkout v1.2.0 -- src/price.js
git add src/price.js
git commit -m "Restore v1.2.0 price formatting"
git status                                        # src/cart.js still modified (your WIP)
```

**Why it works:** `restore --source=<rev> <path>` reads that path from any commit (tags, branches, hashes,
`HEAD~3`, `main@{yesterday}`…) and writes it into your working tree; nothing else is touched — not HEAD, not
other files, not your WIP. Committing after `git add src/price.js` records only the staged path, so the
commit contains just the restore, and `src/cart.js` stays a local modification.

**Why not the alternatives?**
- `git revert` of the two price commits would work here, but needs two reverts and fails if other files were
  touched in the same commits. Restoring one path is exact and independent of how history got there.
- `git checkout v1.2.0` (no `-- path`) detaches HEAD at the tag — you'd be looking at the whole old release.
- `git reset --hard v1.2.0` would throw away Lena's commit, Maya's commit **and** your WIP.

**Real-world notes**
- Write *why* in the message body: `Prices showed $NaN when CURRENCY is unset (v1.3.0). Restoring the v1.2.0
  formatter until Intl version is fixed.` Link the incident/ticket.
- `git restore --source=<rev> --staged --worktree <path>` restores both index and file in one go. Add `-p` to
  restore only some hunks — a great way to cherry-pick *parts* of an old file.
- Directory restores work too (`git restore --source=v1.2.0 -- src/`), but they differ on files that are
  new since then: `git restore` (no-overlay by default) **deletes** them, `git checkout v1.2.0 -- src/`
  (overlay mode) keeps them. Check `git status` afterwards.
- Restoring a file brings back its old *content*, not its old *dependencies*. Run the tests — the rest of the
  code may now expect the new API (`formatPrice(cents, currency)`).
