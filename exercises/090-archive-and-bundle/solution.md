# Solution

From `repo`:

```bash
mkdir -p ../dist ../usb

# 1. the release tarball, from the tag
git archive --format=tar.gz --prefix=brightcart-2.0.0/ -o ../dist/brightcart-2.0.0.tar.gz v2.0.0
tar -tzf ../dist/brightcart-2.0.0.tar.gz                    # no tests/, .github/, docs/internal/
gzip -dc ../dist/brightcart-2.0.0.tar.gz | git get-tar-commit-id   # = git rev-parse v2.0.0^{commit}

# 2. the whole repo in one file
git bundle create ../usb/brightcart.bundle --all            # or: --branches --tags
git bundle verify ../usb/brightcart.bundle                  # "… is okay"
git bundle list-heads ../usb/brightcart.bundle

# 3. the other side
git clone ../usb/brightcart.bundle ../offsite
cd ../offsite
git branch -a && git tag && git fsck
```

**Why it works:**
- `git archive` serializes one tree (here the tree of the commit `v2.0.0` points to) into tar/zip, honouring
  `export-ignore` and `export-subst` attributes **from that tree**. When you archive a commit or tag, the commit
  id is stored in the tar's pax header, which is what `git get-tar-commit-id` reads back: anyone can tell
  exactly which commit a tarball came from. `--prefix` (with a trailing `/`) gives the conventional
  `name-version/` top folder, so unpacking doesn't spill files into the current directory.
- A bundle is a pack of objects plus a header listing refs (and, for incremental bundles, prerequisite
  commits the receiver must already have). Git treats the file as a read-only remote: `clone`, `fetch`,
  `ls-remote` all accept its path. `verify` checks the file is complete and the prerequisites exist.
  `git fsck` on the clone checks every object hash, so a corrupted stick can't sneak in bad data.

**Sending updates later (incremental bundles)**

```bash
# you: only what they don't have yet
git bundle create ../usb/update-2.1.bundle v2.0.0..main release/2.0 --tags
# them:
git bundle verify /media/usb/update-2.1.bundle      # fails if they lack the prerequisite commits
git fetch /media/usb/update-2.1.bundle 'refs/heads/*:refs/remotes/origin/*' --tags
```
Easier still: they set the bundle file as their `origin` URL and you always overwrite the same path on the
stick; `git pull` then just works.

**Real-world notes**
- GitHub's release "Source code (tar.gz)" is a `git archive` of the tag, so `export-ignore` shapes what
  your users download too. Remember the archive has no `.git`: version info must come from a `VERSION` file
  or `export-subst` (`$Format:%H$` placeholders filled in at archive time).
- For reproducible release artifacts, pin the archive's mtime: `git archive --mtime=…` (Git 2.42+), or use
  the commit time, and publish a checksum (`sha256sum`) plus a signature next to the tarball.
- Bundles are also great for: backing up a repo as one file (`git bundle create backup.bundle --all`),
  attaching a repo to a ticket, seeding a huge clone over a fast link before fetching the rest, and Git's own
  `bundle-uri` feature that lets servers offload initial clones to a CDN.
- Air-gapped transfers usually need a paper trail: sign the release tag, record the bundle's checksum, and
  have the receiver verify both before importing.
