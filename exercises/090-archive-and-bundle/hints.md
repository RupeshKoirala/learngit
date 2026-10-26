`git archive` writes a snapshot of one tree-ish, without `.git`. From `repo`:
`git archive --format=tar.gz --prefix=brightcart-2.0.0/ -o ../dist/brightcart-2.0.0.tar.gz v2.0.0`
(Mind the trailing `/` in `--prefix`.) Peek inside with `tar -tzf ../dist/brightcart-2.0.0.tar.gz`.
---
A bundle is a packfile plus a list of refs, in one file that Git can fetch from like a remote:
`git bundle create ../usb/brightcart.bundle --all` (or `--branches --tags`). Then
`git bundle verify ../usb/brightcart.bundle` and `git bundle list-heads ../usb/brightcart.bundle`.
---
Cloning works with a bundle path where you'd normally put a URL:

```bash
git clone ../usb/brightcart.bundle ../offsite
cd ../offsite
git branch -a          # main, remotes/origin/release/2.0
git tag                # v2.0.0
git fsck
```
---
Check the tarball really is 2.0.0: `gzip -dc ../dist/brightcart-2.0.0.tar.gz | git get-tar-commit-id` prints the
commit it was built from; compare with `git rev-parse v2.0.0^{commit}`. `src/giftcards.js` must not be in it.
