# Git in a team: what leads and PMs need to know

Commands are the easy part. Teams struggle with *agreements*: how branches flow, what a good PR is, how releases
are cut, and what happens when production breaks. This page is the cheat sheet for those conversations;
module 11 (exercises 091–099) and module 12 (100–115) let you practice them.

## 1. Branching strategies

| Strategy | How it works | Good for | Watch out for |
|---|---|---|---|
| **Trunk-based** | Everyone merges small PRs into `main` daily; unfinished work hides behind feature flags; release from `main` (or short-lived release branches) | Web apps, continuous deployment, most modern teams | Needs good CI and feature flags; big-bang features must be split |
| **GitHub flow** | Branch from `main` → PR → review + CI → merge → deploy | Small/medium teams, SaaS | Same as trunk-based, slightly longer-lived branches |
| **Release branches** | `release/2.3` cut from `main`; only fixes land there; fixes merged/cherry-picked back to `main`; tags mark versions | Mobile apps, on-prem products, anything with versions customers install | Forgetting to forward-port fixes to `main` (ex. 091–092) |
| **Git flow** (`develop`, `release/*`, `hotfix/*`) | Two long-lived branches | Strict scheduled releases | Heavy; most teams outgrow it |

**The lead's rule of thumb:** short-lived branches (< 2–3 days), small PRs (< 400 changed lines), `main` always
releasable.

## 2. Pull request etiquette

**Authors**
- One purpose per PR. Title says what changes; description says *why*, *how to test*, screenshots for UI,
  risks/rollout notes, and links the issue (`Fixes #123`).
- Clean commits *before* asking for review (rebase -i); after review starts, prefer adding commits (or
  `fixup!` commits) so reviewers can see what changed, then squash at merge.
- Keep the branch updated with `main`; resolve conflicts yourself.
- Draft PRs are for early feedback; mark ready when CI is green.

**Reviewers**
- Review within a working day; small PRs get fast reviews — that's the deal.
- Distinguish blocking issues from nits ("nit:", "optional:"). Use ```suggestion blocks for small fixes.
- Review the design and the tests, not just the diff lines.
- Approve when it's good enough, not when it's how you'd have written it.

## 3. Merge methods on GitHub

| Button | Result on `main` | Use when |
|---|---|---|
| **Create a merge commit** | All PR commits + a merge commit | You want to keep the branch's history and a clear "PR landed here" point |
| **Squash and merge** | One commit per PR | Most teams' default: tidy `main`, PR description becomes the commit message |
| **Rebase and merge** | PR commits replayed linearly, no merge commit | PR commits are already clean and meaningful |

Pick one default per repo (Settings → General) so `git log` stays readable.

## 4. Commit conventions

[Conventional Commits](https://www.conventionalcommits.org): `feat(cart): add gift cards`,
`fix(checkout): round totals`, `chore: bump deps`, `feat!:` or a `BREAKING CHANGE:` footer for breaking changes.
They make changelogs and version numbers automatic (ex. 093–094) and can be enforced with a `commit-msg` hook
(ex. 082) or CI.

## 5. Protecting `main`

Branch protection / rulesets (ex. 106): require PRs, required status checks (CI), at least one approval,
CODEOWNERS review for sensitive paths, linear history (if you squash/rebase), block force pushes and deletions,
require signed commits if your org needs it.

## 6. Releases and versions

- **SemVer** `MAJOR.MINOR.PATCH`: breaking → major, new feature → minor, fix → patch (ex. 094).
- Tag releases with **annotated** tags (`git tag -a v2.0.0 -m "…"`); never move a published tag.
- Release notes come from merged PRs/commits between two tags (ex. 093, 109).
- **Hotfix:** branch from the release tag, fix, tag the patch, and forward-port to `main` (ex. 092).
- **Pulling a feature from a release:** revert it on the release branch, keep it on `main` (ex. 098).

## 7. When production breaks (incident flow)

1. **Stabilize first:** roll back the deploy or revert the PR (`git revert`, GitHub's Revert button) — don't
   debug in production.
2. **Find the cause:** `git log v3.0.0..v3.1.0`, `git bisect run` (ex. 095), `git blame` for context.
3. **Fix forward** with a tested PR; tag a patch release.
4. **Write it down:** timeline, root-cause commit, why CI didn't catch it, follow-up actions. Blameless.

## 8. Ownership and onboarding

- `CODEOWNERS` routes reviews automatically (ex. 099, 108).
- `git shortlog -sn -- path/` tells you who knows a part of the code.
- A `CONTRIBUTING.md`, PR template and issue forms (ex. 108) save every new hire a day of guessing.

## 9. The PM's Git literacy kit

You don't need to rebase, but you should be able to:
- read a PR (description, checks, reviews) and know what "blocked on review" or "red CI" means;
- ask "is this in the release?" and get an answer (`git tag --contains <sha>`, ex. 036);
- understand that merging ≠ deployed ≠ released;
- use issues, milestones, labels and Projects to plan work (ex. 102, 114);
- read a changelog and a version number and know what changed for customers.
