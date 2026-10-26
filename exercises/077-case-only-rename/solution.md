# Solution

```bash
cd repo
git ls-files                               # readme.md, src/Utils.js  <- what every clone gets
git config core.ignorecase                 # true on macOS/Windows

git mv -f readme.md README.md              # -f: "destination exists" on case-insensitive disks (older Git)
git mv src/Utils.js src/utils.tmp          # the two-step rename works everywhere
git mv src/utils.tmp src/utils.js

# src/cart.js: require('./Utils')  ->  require('./utils')
git grep -n "Utils'"                       # nothing left
git commit -am "Normalize file name casing (README.md, src/utils.js)"
git diff -M --name-status HEAD~1
# R100  readme.md     README.md
# R100  src/Utils.js  src/utils.js
# M     src/cart.js
```

**Why it works:** Git's index is case-sensitive: `readme.md` and `README.md` are different paths. A
case-insensitive filesystem isn't, so `mv readme.md README.md` changes nothing Git can see — with
`core.ignorecase=true` it treats the on-disk `README.md` as the tracked `readme.md`. `git mv` edits the **index**
directly, which is what gets committed and what every other machine checks out. Going through a temporary
name makes each step an ordinary rename, so even old Git versions and stubborn editors can't get confused.

Keeping the content identical in the rename commit means Git records a 100 % rename, so `git log --follow
src/utils.js` and `git blame` keep the file's full history.

**Real-world notes**
- **Never "fix" it with `git config core.ignorecase false` on a Mac.** Git would then see `README.md` as a new
  untracked file next to a missing `readme.md`, and you'll end up committing *both* names. A repo containing
  `Utils.js` and `utils.js` is a disaster on macOS/Windows: one file silently overwrites the other on checkout and
  `git status` is dirty right after cloning.
- Detect collisions: `git ls-files | sort -f | uniq -di`. Many teams add this to CI.
- Teammates on case-insensitive disks may keep the old on-disk spelling after pulling (Git sees no change).
  It's harmless to Git but confusing; a two-step `mv` on disk (`mv readme.md tmp && mv tmp README.md`) tidies it.
- Linters/bundlers can enforce matching case (`eslint-plugin-import`'s `no-unresolved` with `caseSensitive`,
  webpack's `CaseSensitivePathsPlugin`) so it's caught on the Mac before CI.
- Pick one convention (lowercase-kebab for files is the most portable) and write it in CONTRIBUTING.
