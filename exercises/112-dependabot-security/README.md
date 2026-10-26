# Dependabot & security basics

Your storefront depends on `lodash 4.17.20` (see `package.json`) - a version with a known vulnerability.
Most breaches don't come from clever hackers; they come from **old dependencies** and **leaked secrets**.
GitHub gives you robots for both. Turn them on like a lead would.

## Your task

1. Through a PR, add **`.github/dependabot.yml`** (`version: 2`) with **two** update entries, both on a
   `weekly` schedule:
   - `package-ecosystem: "npm"`, `directory: "/"`
   - `package-ecosystem: "github-actions"`, `directory: "/"` (keeps `actions/checkout@v4` & co. current)

   Merge it.
2. With `gh api`, enable **Dependabot alerts** (`vulnerability-alerts`) and **Dependabot security updates**
   (`automated-security-fixes`).
3. **Secret scanning + push protection**: enable both via `gh api`. They're free for **public** repos; on a
   private repo without a paid security plan the API refuses - then the check just tells you so (not required).
4. Look around: `gh api repos/{owner}/{repo}/dependabot/alerts`, the repo's **Security** tab, and Dependabot's
   PRs (`gh pr list --author app/dependabot`). Don't merge them blindly - CI first.

## You'll practice

`dependabot.yml`, `gh api -X PUT .../vulnerability-alerts`, `.../automated-security-fixes`,
`security_and_analysis` settings, reading alerts, what **push protection** does when you push a token.
