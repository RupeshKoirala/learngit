# Purge a leaked .env secret from all history

Friday, 16:40. The security channel pings you: *"Is that a live PayFlux key in `.env` on GitHub?"*

It is. Eight commits ago you committed `.env` together with the new payment client, and it has been pushed
ever since — on `main`, on Dev's `feature/refunds` branch and inside the `v0.9` release tag. Deleting the file in
a new commit is **not enough**: anyone can still `git show v0.9:.env`.

```
* Mention tests in README            <- main, origin/main
* Retry failed charges
* ...                                  (6 more)
* Add PayFlux payment client          <- adds .env  (PAYFLUX_SECRET=pfx_live_9f3c…)
* Initial storefront
```

Step zero in real life is to **revoke the key at PayFlux and issue a new one** — that already happened.
The new key is `pfx_live_R0TATED_51b7c2d9e8`. Now clean up Git.

## Your task

In `repo` (its remote `origin` is `../remotes/origin.git`):

1. Remove `.env` from **every commit on every branch and tag** (use `git filter-repo`). All other files and
   commits must survive (`src/payments.js`, the commit `Add PayFlux payment client`, …).
2. `git filter-repo` removes the `origin` remote on purpose — add it back as `../remotes/origin.git`.
3. Make sure it can't happen again: `.gitignore` on `main` must ignore `.env`.
4. Force-push the rewritten `main`, `feature/refunds` **and** the `v0.9` tag. Nothing reachable from origin may
   contain the old key.
5. Recreate your local `.env` with `PAYFLUX_SECRET=pfx_live_R0TATED_51b7c2d9e8` — on disk, ignored, never committed.
6. Leave `main` checked out with a clean working tree.

## You'll practice

`git filter-repo --invert-paths --path`, why filter-repo drops `origin`, `git push --force --all` / `--tags`,
`git log --all -- <path>`, `git check-ignore`, and the incident playbook around a leaked secret.
