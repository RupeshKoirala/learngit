# Ship it offline: git archive and git bundle

Brightcart sells an on-premise edition to a warehouse chain whose network is **air-gapped**: no internet, no
GitHub. Sam (PM) promised their engineer two things on a USB stick for Friday:

1. The **source release 2.0.0** as a tarball: clean, no tests, no CI config, no internal docs.
2. The **whole repository** with history, so they can maintain a branch and receive updates later.

```
* docs: tease gift cards                        <- main
* feat(giftcards): scaffold gift cards
| * fix(checkout): reject empty carts           <- release/2.0
|/
* chore(release): 2.0.0                         (tag v2.0.0)
* feat(checkout): add checkout
* feat(cart): add removeItem
* chore: initial storefront
```

The repo already has a `.gitattributes` with `export-ignore` rules (see the previous exercise).

## Your task

Create the folders `dist/`, `usb/` next to `repo` (in the sandbox folder), then:

1. Build **`dist/brightcart-2.0.0.tar.gz`** from the tag **`v2.0.0`** (not from `main`!) with
   `git archive`, with every path inside under a top folder **`brightcart-2.0.0/`**. The `export-ignore`
   rules must be respected (no `tests/`, `.github/`, `docs/internal/`, `.gitattributes`).
2. Pack the repository into **`usb/brightcart.bundle`** with `git bundle`, including **all branches and
   tags**, and check it with `git bundle verify`.
3. Play the warehouse engineer: **clone from the bundle** into **`offsite`** (next to `repo`) and verify
   the clone: `main` and `release/2.0` are there, the tag `v2.0.0` too, and `git fsck` is happy.

## You'll practice

`git archive --format --prefix -o`, `export-ignore`, `git get-tar-commit-id`, `git bundle create/verify/
list-heads`, cloning and fetching from a bundle file, and `git fsck`.
