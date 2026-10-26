Remote URLs here are paths. From inside `repo/`, the backup server is `../remotes/backup.git`:
`git remote add backup ../remotes/backup.git`. Push to it like to any remote: `git push backup main`.
---
`git push origin main` + `git push backup main` works. Alternatively make `origin` push to both servers at once:
`git remote set-url --add --push origin ../remotes/origin.git` and
`git remote set-url --add --push origin ../remotes/backup.git` — then a plain `git push` writes to both.
---
`git remote set-url gitlab ../remotes/legacy.git`, `git remote rename gitlab legacy` (this also renames
`refs/remotes/gitlab/*` to `refs/remotes/legacy/*` and fixes branch upstreams), then `git fetch legacy`.
---
`git remote remove heroku` deletes the remote's config **and** all `heroku/*` remote-tracking refs.
Verify with `git remote -v` and `git branch -r`.
