# Shallow and partial clones: fast CI, limited history

Sam (PM) asks: *"Who decided free shipping starts at $50? Finance wants the history."* You open the CI
workspace (`repo/`) and run `git blame src/shipping.js` — and **every line** is blamed on the release bot's
`Bump version to 3.2.0`. That can't be right.

`repo/` was made the way most CI systems check code out: `git clone --depth 1`. It contains exactly one commit; Git
"grafts" it, pretending it has no parents:

```
* 8d1c… (grafted, HEAD -> main, origin/main) Bump version to 3.2.0
```

Shallow clones are fast, but `log`, `blame`, `bisect`, `describe` and `merge-base` only see what's there.
**Partial clones** are the modern alternative: full history, but file contents (blobs) are downloaded on demand.

## Your task

1. In `repo/`: confirm it is shallow (`git rev-parse --is-shallow-repository`), look at `git log` and
   `git blame src/shipping.js`.
2. Deepen it step by step (try `--deepen`), watch the history grow, then fetch the **complete** history.
3. Now answer Sam: write the **email address of the author** who originally added the
   `FREE_SHIPPING_THRESHOLD` line into `../ANSWER`.
4. In the sandbox folder, make a **blobless partial clone** of `remotes/origin.git` named `partial`. Note:
   for a local repo you must use a `file://` URL, otherwise Git ignores `--depth`/`--filter`. (`remotes/origin.git`
   already has `uploadpack.allowFilter=true` — GitHub enables this for you.)

## You'll practice

`git clone --depth`, `git rev-parse --is-shallow-repository`, `git fetch --deepen / --depth / --unshallow`,
`git blame -L`, `git clone --filter=blob:none`, and choosing the right clone for CI vs humans.
