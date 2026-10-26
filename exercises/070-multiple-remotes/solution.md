# Solution

```bash
git remote -v

# 1 + 2. a backup mirror for main
git remote add backup ../remotes/backup.git
git push origin main
git push backup main

# 3. fix and rename the moved mirror
git remote set-url gitlab ../remotes/legacy.git
git remote rename gitlab legacy
git fetch legacy

# 4. drop the dead deploy remote
git remote remove heroku

git remote -v
git branch -r
```

Alternative for step 2 — one `git push`, two servers:

```bash
git remote set-url --add --push origin ../remotes/origin.git   # first --push replaces the implicit push URL…
git remote set-url --add --push origin ../remotes/backup.git   # …so add origin itself back explicitly
git push                                                        # pushes to both
```

**Why it works:** a remote is only a name in `.git/config` with a URL (`remote.<name>.url`), optional push URLs
(`remote.<name>.pushurl`) and a fetch refspec that maps its branches to `refs/remotes/<name>/*`. `set-url` edits the
address, `rename` rewrites the config *and* moves the refs and any upstream settings, `remove` deletes both. A push
to a named remote writes only there; push URLs let one name fan out to several servers (fetch still comes from
`url`).

**Real-world notes**
- A real mirror is better done server-side: `git push --mirror backup` from a scheduled job, or GitHub/GitLab's
  built-in push mirroring. `--mirror` copies *all* refs and deletes ones that vanished — powerful and dangerous,
  so never run it from a laptop against a shared repo.
- Typical multi-remote setups: `origin` + `upstream` (forks, exercise 065), `origin` + a deploy remote
  (Heroku/Dokku-style `git push heroku main`), or a company migration (GitHub ↔ GitLab) where both stay in sync for a while.
- When a server moves (new org name, SSH ↔ HTTPS), `git remote set-url origin <new>` is all a teammate needs —
  no re-clone. GitHub redirects renamed repos for a while, but update the URL anyway.
- Removing a remote never touches the server, and your local branches stay; only the tracking refs go.
