# Solution

```bash
git log --oneline -- src/tax.js | wc -l                     # 10 commits touched the file...
git log -L :calculateTax:src/tax.js -s --oneline            # ...but only 4 touched the function
# 8a27a7b Use per-region tax rate
# 9a62c71 Round tax down instead of to nearest
# 7c32821 Tax the discounted subtotal, not the full price
# be627d7 Add flat 20% tax

git log -L :calculateTax:src/tax.js                         # same 4, with function-only diffs
# commit 9a62c71...
#     Round tax down instead of to nearest
#     Finance wants to never over-charge tax by a cent (FIN-31).
# -  return Math.round(taxable * 0.2);
# +  return Math.floor(taxable * 0.2);
git tag rounding-change 9a62c71

git show --stat 9a62c71
#  CHANGELOG.md       | 1 +
#  src/tax.js         | 2 +-
#  tests/tax.test.sh  | 1 +
#  3 files changed, 3 insertions(+), 1 deletion(-)

git grep TAX_RATE_EU                 # nothing today
git grep TAX_RATE_EU v1.0
# v1.0:src/legacy/vat.js:const TAX_RATE_EU = 0.21;
```

`../ANSWER`:
```
q1=4
q2=3
q3=src/legacy/vat.js
```

For the auditor: $9.99 × 20% = 199.8 cents, and since **FIN-31** (commit `9a62c71`) tax is rounded *down*,
so $1.99 is intended. That's a business decision with a ticket, not a bug.

**Why it works**
- **`git log -L :name:file`** finds the function using Git's "funcname" rules (the same ones that show
  the `@@ ... function calculateTax` hunk headers), then walks history backwards following that line range.
  Lines move as other code is added above (`rateFor`, `roundCents` here), and `-L` follows them. You can
  also give explicit ranges: `-L 12,16:src/tax.js` or regexes: `-L '/function calculateTax/,/^}/:src/tax.js'`.
- **`git show --stat`** prints the commit plus a per-file summary. `--name-only` or `--name-status`
  print just paths (and A/M/D). It's the quickest "how big was this change" check.
- **`git grep <pattern> <tree-ish>`** searches a snapshot straight from the object database: no checkout, no
  stash, your working tree untouched. Any revision works: `v1.0`, `main~20`, `origin/release/1.3`.

**Real-world notes**
- `log -L` is ideal for code archaeology before you change a function: *"this was floor on purpose,
  FIN-31"* is exactly the kind of thing a reviewer will ask about.
- For languages where Git's default funcname rule misfires (e.g. C# methods, Python methods inside classes),
  set a diff driver in `.gitattributes` (`*.py diff=python`) and `-L :name:` and hunk headers get smarter.
- `git grep` is much faster than plain `grep -r` (it only searches tracked files and skips `node_modules`),
  and it takes the same flags: `-n`, `-l`, `-c`, `-w`, `-e A --and -e B`.
- To search *every* version at once: `git grep TAX_RATE_EU $(git rev-list --all)`. It's heavy, but
  sometimes it's the only way to find where something lived.
- Communicating with a PM or auditor: lead with the answer ("intended, FIN-31, since 9a62c71"), then link
  the evidence. They don't need the `git log` output, they need the decision and the ticket.
