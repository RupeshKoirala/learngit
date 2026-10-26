`git bisect run <cmd>` runs `<cmd>` at every step: exit 0 means good, 1–127 means bad, except **125**, which means
"skip this commit". Try the naive version first to see the trap:
```bash
git bisect start main v2.0
git bisect run sh test/run.sh
git bisect reset
```
Which commit did it blame? Does that commit really contain the bug?
---
The naive run blames `WIP: move price formatter...`, where `bin/price` was deleted. The tests fail there for a
different reason. Your script must recognise "can't build/test" and exit 125 for it.
---
```sh
#!/bin/sh
# ../bisect-test.sh
[ -f bin/price ] || exit 125      # untestable: half-finished refactor
exec sh test/run.sh               # 0 = good, 1 = bad
```
`chmod +x ../bisect-test.sh`. Bisect runs it from the repo root, so relative paths work.
---
```bash
git bisect start main v2.0
git bisect run ../bisect-test.sh
git tag first-bad refs/bisect/bad     # before resetting!
git bisect reset
```
