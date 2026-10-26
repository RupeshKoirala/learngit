First confirm the blast radius: `git log --all --oneline -- .env` lists every commit (on any branch or tag)
that touched the file. `git show v0.9:.env` proves a plain "delete it" commit wouldn't help.
---
`git filter-repo --invert-paths --path .env` rewrites history keeping everything *except* that path.
It refuses to run on a repo that "doesn't look like a fresh clone" — that's a safety net; here you can add
`--force` (or do the rewrite in a fresh `git clone --mirror` and push from there).
---
filter-repo deletes the `origin` remote so you can't accidentally push half-done work.
`git remote add origin ../remotes/origin.git`, then commit `.env` in `.gitignore`, then
`git push --force origin --all` and `git push --force origin --tags`.
---
The rewrite also deletes `.env` from your disk (it's no longer tracked). You don't need the old value — it's
revoked. Recreate it: `printf 'PAYFLUX_SECRET=pfx_live_R0TATED_51b7c2d9e8\n' > .env` and check
`git check-ignore -v .env` and `git status`.
