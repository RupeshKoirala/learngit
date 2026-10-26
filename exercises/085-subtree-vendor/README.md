# git subtree: vendor a library and pull its updates

The platform team (Dev) publishes **pricing-rules**, the shared rounding and tax logic, in its own repo with
tagged releases. The storefront needs it. Last quarter the admin app tried submodules and the support team
kept downloading ZIPs from GitHub with an empty folder inside. Maya wants something boring: **a plain copy of
the library inside the storefront repo**, that can still be updated from upstream with one command.
That's `git subtree`.

```
remotes/pricing-rules.git   * feat: add French VAT                       (tag v1.1.0) <- main
                            * fix: round half up instead of truncating
                            * test: rounding cases                       (tag v1.0.0)
                            * feat: tax rules
                            * feat: rounding rules
repo/                       * chore(price): note shared rounding todo                 <- main
                            * chore: initial storefront
```

## Your task

In `repo`, on `main`:

1. QA certified **v1.0.0**. Vendor that release into **`vendor/pricing-rules/`** with `git subtree add`,
   **squashed** so the library's internal history doesn't flood ours. (Tip: add the library as a remote named
   `pricing-rules` first, URL `../remotes/pricing-rules.git`.)
2. Then the rounding fix comes out: update the vendored copy to **v1.1.0** with `git subtree pull`, squashed.

When you're done:
- `vendor/pricing-rules/` contains exactly the files of upstream v1.1.0, as normal tracked files (no
  submodule, no `.gitmodules`).
- History has one squash commit per imported release (Git writes `git-subtree-split: <hash>` into them), and
  none of upstream's individual commits.
- Nothing outside `vendor/` changed; you're on a clean `main`.

## You'll practice

`git subtree add` / `pull` with `--prefix` and `--squash`, reading the `git-subtree-*` trailers, and choosing
between subtree, submodule and a package manager.
