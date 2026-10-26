The branch is on `origin` and Lena has local work built on it. A rebase rewrites every commit (new hashes), so
she'd have to untangle her work and everyone's links to these commits break. Team rule of thumb: **never
rewrite a shared branch** — merge `main` into it. Write `merge` into `../ANSWER`, then `git merge main`.
---
Read `git status` carefully — there are three kinds of conflict:
- `README.md` (content): keep both new sections.
- `lib/currency.sh` (*file location*): Git noticed `src/` became `lib/` and already moved your new file. Just `git add lib/currency.sh`.
- `src/money.sh` (*modify/delete*): `main` moved **and** rewrote the file, so Git didn't recognise the rename.
  Compare `git show :1:src/money.sh` (base), `:2:` (yours) and `lib/money.sh` (main's).
---
Port the currency feature into `lib/money.sh` on top of main's refund logic (sign first, then the symbol):
```sh
format_price() {
  _c=$1; _sign=''
  if [ "$_c" -lt 0 ]; then _sign='-'; _c=$((-_c)); fi
  case "${2:-USD}" in EUR) _sym='EUR ' ;; GBP) _sym='GBP ' ;; *) _sym='$' ;; esac
  printf '%s%s%d.%02d\n' "$_sign" "$_sym" $((_c / 100)) $((_c % 100))
}
```
Then `git rm src/money.sh`.
---
Run `./test.sh` *before* committing the merge: `tests/test_currency.sh` (written three months ago) still sources
`./src/…` — a semantic conflict Git can't detect. Point it at `./lib/`, `git add` everything, `git commit`.
Then `git switch main && git merge --no-ff feature/multi-currency && git push origin main feature/multi-currency`.
