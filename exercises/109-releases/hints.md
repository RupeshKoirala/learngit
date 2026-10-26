`git switch main && git pull`, then `git tag -a v1.0.0 -m "Brightcart 1.0"` and `git push origin v1.0.0`.
`git show v1.0.0` shows the tag object (tagger, message) before the commit.
---
`gh release create` takes the tag name, then any files to upload. `--verify-tag` refuses to create a new
tag if yours isn't on GitHub yet (protects you from typos).
---
```
./build.sh 1.0.0
gh release create v1.0.0 dist/brightcart-1.0.0.tar.gz --verify-tag --title "Brightcart 1.0" --generate-notes
```
---
Check it: `gh release view v1.0.0` (or `--web`). Forgot the file? `gh release upload v1.0.0 dist/brightcart-1.0.0.tar.gz`.
Notes look wrong? `gh release edit v1.0.0 --notes-file notes.md`.
