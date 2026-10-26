# Search the log like a detective

Brightcart's storefront has ~20 commits from five people over three months. Sam (PM) is writing the
quarterly report and Maya is chasing a regression; both come to you with questions. Scrolling through
`git log` won't cut it — use the log's search options.

## Your task

Find each commit and mark it with a **tag** of exactly this name (`git tag <name> <commit>`):

| Tag | The commit that… |
|---|---|
| `lena-first` | is **Lena Okafor's first** commit ever in this repo |
| `march-hotfix` | is the **only** commit made between **March 1 and March 7, 2025** |
| `issue-42` | **closes issue #42** (the issue number is mentioned somewhere in the commit message) |
| `tax-file` | **created** the file `src/tax.js` |
| `freeship-added` | **introduced** the promo code `FREESHIP50` into the code |

Don't create commits or move `main`. Several decoys are hidden in the history: misleading subjects, two
commits with the same message, a "#24" and a "1.42"…

## You'll practice

`git log --oneline`, `--author`, `--since/--until`, `--grep` (and `-i`, `--all-match`), `--reverse`,
`-- <path>` and `--diff-filter=A`, the pickaxe `-S` / `-G`, `--format`, and `git tag <name> <commit>`.
