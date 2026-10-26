# Submodules: share a UI kit, bump it, clone it right

Lena maintains Brightcart's shared CSS components in their own repository, **ui-kit**, used by the storefront,
the admin app and the email templates. Maya decided the storefront should consume it as a **Git submodule**:
the storefront repo records *exactly which ui-kit commit* it was tested with.

```
remotes/ui-kit.git        * feat: card component   (tag v1.0.0)  <- main
                          * feat: button styles
remotes/storefront.git    * feat(cart): add removeItem           <- main
repo/                     your clone of storefront
```

**Heads-up:** these fake remotes are local folders. Since Git 2.38, submodule commands refuse local paths
unless you opt in, so add `-c protocol.file.allow=always` right after `git` for commands that touch
submodules, e.g. `git -c protocol.file.allow=always submodule add …`. (Real HTTPS/SSH remotes don't need it.)

## Your task

1. In `repo`, add ui-kit as a submodule at **`libs/ui-kit`**. Use the **relative URL `../ui-kit.git`** (it's
   resolved against the storefront's own `origin`, so it keeps working whether people clone via SSH or HTTPS).
   Commit it (`.gitmodules` + `libs/ui-kit`) and **push** to `origin main`.
2. Run **`./lg event`**: Lena releases **v1.1.0**… and then pushes an unfinished `wip:` commit on top of it.
3. Bump the storefront to **exactly the `v1.1.0` tag** (not the newer `wip` commit). Commit the new pointer and
   push.
4. Prove a teammate gets everything in one go: clone `remotes/storefront.git` with submodules into
   **`fresh`** (next to `repo`, i.e. `$(./lg where)/../fresh`). Its `libs/ui-kit` must be populated at v1.1.0.
5. `cd fresh/libs/ui-kit && git status` says `HEAD detached at …`. The superproject doesn't store a branch for
   the submodule, it stores a commit. Write **that commit hash** (short is fine) into a file named `ANSWER`
   next to `repo` (find it with `git submodule status` or `git ls-tree HEAD libs/ui-kit`).

Finally, leave `repo` clean with `libs/ui-kit` checked out at v1.1.0.

## You'll practice

`git submodule add`, `.gitmodules`, gitlinks (mode `160000`), bumping a submodule pointer,
`git clone --recurse-submodules`, `git submodule update --init`, detached HEAD in submodules, and
`protocol.file.allow`.
