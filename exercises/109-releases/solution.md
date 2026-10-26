# Solution

```bash
cd "$(./lg where)"
git switch main && git pull
git tag -a v1.0.0 -m "Brightcart 1.0 - first public release"
git push origin v1.0.0
./build.sh 1.0.0
gh release create v1.0.0 dist/brightcart-1.0.0.tar.gz \
  --verify-tag --title "Brightcart 1.0" --generate-notes
gh release view v1.0.0 --web
```

**Why it works:** an annotated tag is a real object (tagger, date, message, optionally signed) pointing at a
commit - that's what `git describe` and release tooling expect. A GitHub Release is GitHub metadata on top
of a tag: notes, assets, "latest" badge. `--generate-notes` lists merged PRs between the previous release and
this tag, grouped and credited, plus a "Full Changelog" compare link.

**Real-world notes**
- **SemVer**: MAJOR.MINOR.PATCH - breaking change, new feature, bug fix. `v1.0.0` is the "we promise
  compatibility" moment. Pre-releases: `v1.1.0-rc.1` with `--prerelease`.
- Tags are meant to be **immutable**. Never move a published tag; ship `v1.0.1`. Protect `v*` tags with a tag
  ruleset so nobody can delete or retarget them.
- Generated notes come from **PR titles** - one more reason for good titles. `.github/release.yml` groups them
  by label (Features / Fixes / Chores) and excludes bots.
- Real pipelines build artifacts **in CI** from the tag (`on: push: tags: ['v*']`), attach them and publish
  checksums/SBOMs, so the binary provably matches the source. Release drafts let the PM polish the text first.
- Ops/support: `gh release download v1.0.0 -p '*.tar.gz'` fetches exactly what shipped.
