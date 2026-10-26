# Solution

```bash
cd repo
git -c protocol.file.allow=always submodule add ../ui-kit.git libs/ui-kit
git diff --cached              # .gitmodules + "Subproject commit <hash>" for libs/ui-kit
git commit -m "build: add ui-kit as a submodule"
git push

# run ./lg event from your learngit folder: Lena ships v1.1.0 (+ a wip commit)

cd libs/ui-kit
git fetch --tags
git switch --detach v1.1.0     # HEAD detached at v1.1.0 -- that's normal in a submodule
cd ../..
git status                     # modified: libs/ui-kit (new commits)
git diff --submodule=log       # lists the ui-kit commits you're pulling in -- paste into the PR
git add libs/ui-kit
git commit -m "build: bump ui-kit to v1.1.0"
git push

cd ..
git -c protocol.file.allow=always clone --recurse-submodules remotes/storefront.git fresh
git -C fresh submodule status  # " 5f3a9c1 libs/ui-kit (v1.1.0)"
git -C fresh submodule status | cut -c2-8 > ANSWER
```

**Why it works:** a submodule is two things in the superproject: an entry in `.gitmodules` (path → URL, for
cloning) and a **gitlink** in the tree, mode `160000`, whose value is one commit hash of the other repo. That
hash *is* the version. Nothing about branches is stored, so when Git checks the submodule out it checks out
that exact commit — a detached HEAD. Bumping is therefore "move the submodule's HEAD, then `git add` the path"
so the superproject records the new hash, exactly like changing a file.

`clone --recurse-submodules` = `clone` + `git submodule update --init --recursive`. A plain clone leaves
`libs/ui-kit` as an empty folder (`git submodule status` shows a leading `-`).

The relative URL `../ui-kit.git` is resolved against the superproject's `origin`. Clone over SSH and you get
ui-kit over SSH; clone over HTTPS and you get HTTPS. Absolute URLs break one of the two.

**Real-world notes**
- The #1 submodule bug: someone commits in the submodule, bumps the pointer in the superproject, but **forgets
  to push the submodule**. Everyone else gets `fatal: … not our ref`. Use
  `git push --recurse-submodules=check` (or `=on-demand`) and set it as `push.recurseSubmodules`.
- Set `git config --global submodule.recurse true` so `pull`, `switch` and `checkout` also update submodules;
  otherwise `git pull` changes the pointer but leaves the old code checked out (shows as `+` in
  `git submodule status`).
- Want to work *on* ui-kit from inside the storefront? `cd libs/ui-kit && git switch main` first, otherwise
  your commits land on a detached HEAD and are easy to lose.
- `git submodule update --remote` follows a branch (`submodule.<name>.branch`, default the remote HEAD). Handy
  for "track latest", dangerous when latest includes `wip:` commits — pin tags for releases.
- Bots like Dependabot and Renovate can open PRs that bump submodule pointers for you.
- Submodules fit "independent project with its own release cycle". If people constantly edit both sides
  together, a monorepo or `git subtree` (next exercise) usually hurts less.
- `protocol.file.allow` exists because a malicious repo could use a local-path submodule to read files on
  your machine (CVE-2022-39253). Only allow it for repos you trust, as you did here with `-c` per command.
