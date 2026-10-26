`git -c protocol.file.allow=always submodule add ../ui-kit.git libs/ui-kit` clones ui-kit into `libs/ui-kit`
and stages two things: the `.gitmodules` file and a special entry `libs/ui-kit` that is just a commit hash.
Look at `git diff --cached`. Then `git commit -m "build: add ui-kit as a submodule"` and `git push`.
---
To bump, go *into* the submodule: it's a normal repo. `cd libs/ui-kit`, `git fetch --tags`, then
`git switch --detach v1.1.0` (or `git checkout v1.1.0`). Back in the storefront, `git status` shows
`modified: libs/ui-kit (new commits)`. `git add libs/ui-kit`, commit, push.
---
`git submodule update --remote` would jump to the tip of ui-kit's `main`, which is the `wip:` commit.
That's why we bump by tag here. Verify with `git submodule status` (it prints the hash and `(v1.1.0)`).
---
From the sandbox folder (`cd ..` from `repo`):

```bash
git -c protocol.file.allow=always clone --recurse-submodules remotes/storefront.git fresh
git -C fresh submodule status          # the hash, without a leading '-' (= initialized)
git -C fresh submodule status | cut -c2-8 > ANSWER
```
Forgot `--recurse-submodules`? `git -c protocol.file.allow=always submodule update --init --recursive`.
