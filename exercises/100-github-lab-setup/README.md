# Set up your GitHub lab

Brightcart is moving to GitHub, and from now on you practise the GitHub side of the job for real: pull
requests, reviews, CI, releases, projects. Everything in this module (100-115) happens in **one** private
repository of yours called `learngit-lab`, so it lives *outside* the per-exercise sandboxes and is never wiped:

```
~/learngit-playground/github-lab     <- local project, already seeded (./lg where prints the path)
github.com/<you>/learngit-lab        <- doesn't exist yet: you create it now
```

The local repo has a small history but no remote:

```
* Add package.json and build script    <- main
* Add removeItem to cart
* Initial storefront
```

## Your task

1. Make sure the GitHub CLI is logged in: `gh auth status` must show your account. (If it doesn't:
   `gh auth login` -> GitHub.com -> HTTPS -> "authenticate Git with your GitHub credentials" -> yes.)
2. From inside `github-lab`, create a **private** GitHub repo named `learngit-lab` **from the existing folder**
   and push `main` - in **one** `gh` command. Afterwards `origin` points at the new repo and local `main`
   tracks `origin/main`.
3. Give the repo a description that mentions **Brightcart** and the topics `git` and `brightcart`.

## You'll practice

`gh auth status`, `gh repo create --source --push`, `gh repo edit`, `gh repo view`, and what `origin` and
upstream tracking mean for a brand-new repo.
