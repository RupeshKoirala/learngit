# Monorepo tricks: partial clone + sparse-checkout

Brightcart moved every service into one **monorepo**. It's great for atomic cross-service changes, but your
full clone (`repo`) drags along every version of every product image ever committed, and your editor indexes
search, catalog and web code you never touch. You only work on **payments**.

Two features fix this, and they combine:
- **Partial clone** (`--filter=blob:none`): download all commits and trees, but file contents (blobs) only
  when Git actually needs them.
- **Sparse-checkout** (cone mode): only materialize some folders in your working tree.

```
remotes/monorepo.git
├── README.md  CODEOWNERS  .gitignore
├── assets/            catalog-images.bin, hero-banner.bin  (6 big versions each in history)
├── services/payments/ README.md  index.js  retry.js
├── services/catalog/  services/search/
└── web/
```

## Your task

Work from the sandbox folder (the parent of `repo`).

1. You also play "server admin": our fake remote must allow filtered clones. Enable
   **`uploadpack.allowFilter`** in `remotes/monorepo.git` (GitHub and GitLab have it on).
2. Make a **partial (blobless) clone** of the monorepo into **`slim`**, starting **sparse** (only top-level
   files). Careful: for a local path Git ignores `--filter` and warns; use a `file://` URL with an absolute
   path, e.g. `"file://$PWD/remotes/monorepo.git"`.
3. In `slim`, set sparse-checkout in **cone mode** to just **`services/payments`**.
4. In `slim`, create branch **`fix/payments-timeout`**, change `TIMEOUT_MS = 5000` to **`TIMEOUT_MS = 15000`** in
   `services/payments/retry.js`, commit (only that file), and **push** the branch to `origin`.

`./lg check` verifies that `slim` is a real partial clone (old blobs genuinely missing), shows only
`services/payments/` plus the top-level files, and that your branch reached the remote.

## You'll practice

`git clone --filter=blob:none --sparse`, `git sparse-checkout set/list/add/disable`, cone mode,
promisor remotes, `uploadpack.allowFilter`, and `git count-objects -vH` to see the difference.
