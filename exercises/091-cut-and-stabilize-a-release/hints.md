Find the cut point first: `git log --oneline --grep "code freeze"`. A branch can start at any commit:
`git switch -c release/2.0 <hash>` (or `git switch -c release/2.0 ':/code freeze'`).
---
Make each fix, run `./test.sh`, and commit them one at a time, e.g. `fix(checkout): tax rate is 8% (BC-201)` and
`fix(price): show two decimals (BC-202)`. `git log --oneline main..release/2.0` lists what the release branch
has that `main` doesn't — right now, exactly your two fixes.
---
`git tag -a v2.0.0 -m "Brightcart 2.0.0"` creates an annotated tag (it has a tagger, date and message —
`git show v2.0.0` proves it). Then `git switch main && git merge --no-ff release/2.0`.
---
`git push` doesn't send tags by default. Use
`git push origin main release/2.0 v2.0.0` (or `git push --follow-tags origin main release/2.0`, which pushes
annotated tags that point into what you push). `git ls-remote --tags origin` shows what the server has.
