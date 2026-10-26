# Releases

Sam (PM) wants to announce **Brightcart 1.0** to customers and needs a page to link to; ops wants the exact
build that shipped. A Git tag marks the commit; a **GitHub Release** wraps that tag with notes and files.

## Your task

1. On an up-to-date `main`, create an **annotated** tag **`v1.0.0`** (with a message) and push it.
2. Build the artifact: `./build.sh 1.0.0` -> `dist/brightcart-1.0.0.tar.gz` (dist/ is git-ignored).
3. Create a GitHub **Release** for `v1.0.0` with **generated release notes** (`--generate-notes`), a title, not
   a draft, and **attach** `dist/brightcart-1.0.0.tar.gz`.

## You'll practice

`git tag -a`, `git push origin v1.0.0`, `gh release create --generate-notes --verify-tag`, uploading assets,
`gh release view / list / download`, semantic versioning.
