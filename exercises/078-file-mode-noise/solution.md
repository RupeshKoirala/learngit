# Solution

```bash
cd repo
git show --summary HEAD | grep mode         # mode change 100644 => 100755 README.md ... (6 files)
git ls-files -s | grep ^100755              # the offenders

git ls-files -s | awk '$1 == "100755" {print $4}' | xargs chmod 644
git add -A                                  # with core.fileMode=true, git sees the x-bit going away

git update-index --chmod=+x test.sh         # flip the bit in the index …
chmod +x test.sh                            # … and on disk, so the tree is clean

git diff --cached --summary                 # only "mode change" lines, no content
git commit -m "Restore file modes; make test.sh executable"
./test.sh
```

**Why it works:** Git doesn't store real Unix permissions. For a regular file it records one bit — executable
(`100755`) or not (`100644`) — as part of the tree. A mode change is a real change: it shows up in diffs, merges
and blame, it can conflict, and it gives every file a scary "modified" history. `core.fileMode=true` (the default
on Linux/macOS) makes Git read the executable bit from disk; `git update-index --chmod` sets it in the index
directly, which is the only way when your disk can't express it (Windows, some network drives, WSL on NTFS).

**Real-world notes**
- **`core.fileMode=false` hides, it doesn't fix.** It tells Git to ignore permission differences on *your* disk,
  which is right on Windows/FAT/NTFS mounts where every file looks executable — but the wrong 100755 entries stay in
  the repo for everyone else. Fix the repo, then decide the setting per machine.
- On Windows (`core.fileMode=false` by default) `git update-index --chmod=+x script.sh` is *the* way to ship an
  executable script; otherwise CI on Linux gets `Permission denied`.
- Review PRs with the file list: GitHub shows "file mode changed 100644 → 100755"; a source file
  should almost never need that change. A CI check like
  `git ls-files -s | awk '$1=="100755"' | grep -v '\.sh$'` catches it.
- Also look for its cousins: line-ending churn (CRLF, use `.gitattributes` `* text=auto`) and whitespace-only
  reformat commits. Put mass reformat commits in `.git-blame-ignore-revs` so `git blame` skips them.
