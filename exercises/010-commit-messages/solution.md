# Solution

```bash
git diff --staged --stat        # know what you're describing
git commit                      # opens your editor
```

```
Prevent adding more items than in stock

Orders failed at payment when the cart held more units than the
warehouse had. Check stock when an item is added so customers see
the problem immediately instead of at checkout.

Closes #12
Co-authored-by: Lena Okafor <lena@brightcart.example>
```

```bash
git log -1                                                   # read it back
git log -1 --format='%(trailers)'      # see the nuance about trailers below
```

Or without an editor:
```bash
git commit -m "Prevent adding more items than in stock" \
           -m "Orders failed at payment when ... at checkout." \
           --trailer "Closes: #12" \
           --trailer "Co-authored-by: Lena Okafor <lena@brightcart.example>"
```
(`--trailer` needs Git 2.32+. Each `-m` becomes its own paragraph; you still have to wrap the body yourself.)

**Why it works / why these rules:**
- **≤ 50-char subject**: it's what `git log --oneline`, GitHub's commit list, `git shortlog`, email
  subjects (`format-patch`) and release-note tools show. Long subjects get truncated with "…".
- **Imperative mood** matches Git's own messages ("Merge branch…", "Revert…") and reads as an instruction:
  *If applied, this commit will* **prevent adding more items than in stock**.
- **Blank line**: Git treats everything before the first blank line as the subject. No blank line → your
  whole body becomes one giant subject.
- **Body wrapped at 72**: Git doesn't wrap; `git log` indents by 4, so 72 keeps it readable in an 80-column
  terminal. Explain *why* — the diff already shows *how*.
- **Trailers** are machine-readable `Key: value` lines in the last paragraph. Nuance: `git interpret-trailers`
  only treats that paragraph as trailers if its lines are *all* `Key: value` (or it contains a Git-known key like
  `Signed-off-by`), so `Closes #12` without a colon makes Git skip the block. GitHub is more lenient and
  honours both lines anyway; if your tooling parses trailers strictly, write `Closes: #12`.
  GitHub closes `#12` when the commit lands on the default branch, and shows Lena as co-author (her email must match her GitHub account).
  Teams also use `Reviewed-by:`, `Refs: JIRA-123`, `Signed-off-by:` (`git commit -s`, required by many
  open-source projects as a DCO).

**Real-world notes**
- Many teams enforce conventions with `commitlint` in a `commit-msg` hook or CI; some use **Conventional
  Commits** (`feat(cart): prevent adding more items than in stock`) to generate changelogs and semantic
  version bumps automatically. Know both styles; follow the team's.
- Set a template so you never start from a blank page:
  `git config --global commit.template ~/.gitmessage` (a file with the structure and `#` reminder comments).
- With "Squash and merge" on GitHub, the PR title becomes the commit subject — so PR titles deserve the same
  50-char, imperative care, and the PR description should explain *why*, like a commit body.
- A good test: could a teammate decide whether to revert this commit *from the message alone*?
