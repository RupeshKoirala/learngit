# Multiple remotes: backup mirror, set-url, rename, remove

A repository can talk to any number of remotes — `origin` is just the default name. Your clone has collected a few
over the years. `git remote -v`:

```
gitlab  .../remotes/gitlab-old.git (fetch)    <- the old GitLab mirror; it moved to remotes/legacy.git
gitlab  .../remotes/gitlab-old.git (push)
heroku  .../remotes/heroku.git (fetch)        <- old deploy target, the app no longer runs there
heroku  .../remotes/heroku.git (push)
origin  .../remotes/origin.git (fetch)        <- the team's main repo
origin  .../remotes/origin.git (push)
```

Maya (tech lead) after last month's outage: *"I want every commit on `main` to also land on our backup server
(`remotes/backup.git`). And clean up those old remotes, please."*

You also have one unpushed commit on `main`: `Add returns policy page`.

## Your task

1. Add a remote named **`backup`** for `remotes/backup.git` (it's empty).
2. Push `main` so that **both `origin` and `backup`** have your new commit.
3. The `gitlab` remote's address is outdated: point it at `remotes/legacy.git`, **rename** it to **`legacy`**,
   and fetch from it so `legacy/main` exists.
4. **Remove** the `heroku` remote (and with it, its `heroku/*` remote-tracking branches).
5. `origin` must keep fetching from `remotes/origin.git`.

## You'll practice

`git remote add / -v / get-url / set-url / rename / remove`, `git push <remote> <branch>`, and the trick of giving
one remote **two push URLs** (`git remote set-url --add --push`).
