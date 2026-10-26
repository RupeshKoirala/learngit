`git log -S'some text'` lists only the commits where the number of times `some text` appears in the code
went **up or down**, which means the commits that added or removed it. Add `--oneline` to keep it short and
`-p` to see the diffs.
---
`git log --oneline -S'function applyCoupon'` gives exactly two commits: the one that added the function and
the one that removed it. The newest is listed first. `git show <hash>` shows what replaced it.

(Plain `-S applyCoupon` lists more commits, because callers and docs mention the name too. A more specific
search string gives fewer false positives.)
---
For the regex, `-S EMAIL_RE` doesn't work: editing the pattern doesn't change how many times the *name*
`EMAIL_RE` appears. `-G` matches every commit whose diff adds or removes a line matching a regex:
```bash
git log --oneline -G'EMAIL_RE'                   # includes docs commits
git log -p -G'EMAIL_RE' -- src/validate.js       # code only, with diffs
```
Look for the diff where `[a-z0-9._+-]` turns into `[a-z0-9._-]`.
---
```bash
git tag removed-applyCoupon <newer hash from -S'function applyCoupon'>
echo redeem...     > ../ANSWER     # the new name you saw in git show
git tag regex-change <hash of the diff that dropped the +>
```
