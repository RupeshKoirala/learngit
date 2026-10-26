# Protect main

So far anyone with write access (you, a script, a tired colleague at 2 a.m.) can push straight to `main`,
force-push over it, or delete it. As the lead, you make the rules **enforced by GitHub**, not by a wiki page.

## Your task

Using **`gh api`** (the web UI is fine to explore, but script it - leads keep this in code), protect `main`
with **either** classic branch protection **or** a repository ruleset so that:

1. changes need a **pull request** - with **0 required approvals** in this solo lab (you can't approve your own
   PRs; real teams use 1-2, see the solution),
2. **linear history** is required (no merge commits on main),
3. **force pushes** to main are blocked,
4. **deleting** main is blocked,
5. the rules apply to **admins too** - i.e. to you (classic: `enforce_admins`; ruleset: no bypass actors).

Then **prove it**: make a small commit on local `main`, `git push` it, and watch GitHub reject it. Copy the
`remote: error: GH0..` line into a file named `ANSWER` in this exercise's sandbox - from inside the
lab that's `../106-protect-main/ANSWER`. Finally undo the local
commit so `main` matches `origin/main` again.

Optional now, required in 107: a **required status check** named `test` (your CI job's name). If you add it
already, PRs can't be merged until the CI from exercise 107 exists - so do 107 right after.

> **GitHub Free + private repo?** Protection and rulesets are paid features for private repos. The API answers
> `403 Upgrade to GitHub Pro or make this repository public`. The lab holds only demo code, so make it public:
> `gh repo edit --visibility public --accept-visibility-change-consequences`.

## You'll practice

`gh api -X PUT repos/{owner}/{repo}/branches/main/protection --input`, `gh api repos/{owner}/{repo}/rulesets`,
`gh api repos/{owner}/{repo}/rules/branches/main`, reading a rejected push, `git reset --hard origin/main`.
