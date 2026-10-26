`git log -L` follows a *range of lines* back through history, even as lines move around in the file. Git
can find the range for you from a function name: `git log -L :calculateTax:src/tax.js`.
---
`git log -L :calculateTax:src/tax.js` shows each commit with only the part of the diff that touches the
function. Add `-s --oneline` to list just the commits so you can count them (q1). Compare with
`git log --oneline -- src/tax.js`: far more commits touched the file.
In the `-L` output, find the diff where `Math.round` became `Math.floor`.
---
`git show --stat <hash>` lists every file a commit changed, with a summary line (`N files changed`). This
answers q2. `--name-only` gives just the paths.
`git grep <pattern> <rev>` searches a whole snapshot without checking it out:
`git grep TAX_RATE_EU v1.0` prints `v1.0:<path>:<line>`.
---
```bash
git log -L :calculateTax:src/tax.js -s --oneline            # count -> q1
git log -L :calculateTax:src/tax.js | less                  # find Math.round -> Math.floor
git tag rounding-change <hash>
git show --stat <hash>                                       # "N files changed" -> q2
git grep TAX_RATE_EU v1.0                                    # q3 = the path between "v1.0:" and the next ":"
```
