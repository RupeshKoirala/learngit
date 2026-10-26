# Review a teammate's pull request locally

Lena opened **PR #42 "Free shipping above 50 dollars"** from her fork and asked you to review it. The diff
looks small on GitHub, but you never approve shipping logic without running it.

The PR isn't a branch in the company repo — it lives on Lena's fork. GitHub still keeps a copy of every PR's
commits in the base repo under a hidden ref: **`refs/pull/<number>/head`**. `git clone` and `git fetch` don't
download those by default. (In this sandbox, `remotes/origin.git` has `refs/pull/42/head` and `refs/pull/43/head`
just like GitHub would.)

```
* Spec: free shipping threshold   <- main, origin/main
* Initial storefront
        refs/pull/42/head on origin: 2 commits by Lena on top of main  (invisible in your clone)
```

## Your task

1. Fetch PR #42 into a local branch named **`pr-42`**.
2. Check it out, run `./test.sh`, and compare the code with the product spec in `docs/shipping.md`.
3. Write your review into `../ANSWER`:
   - first line: your verdict, either `approve` or `request changes`;
   - then at least one review note that names the **file** and the **problem**.
4. Configure `origin` so that every future `git fetch` also brings all PRs as `origin/pr/<number>`, and fetch.
   (`origin/pr/42` and `origin/pr/43` should appear.)
5. Don't push anything and don't change `main`. It's Lena's PR — she fixes it.

## You'll practice

`git fetch origin <ref>:<branch>`, `git ls-remote origin`, refspecs (`+refs/pull/*/head:refs/remotes/origin/pr/*`),
`git log main..pr-42`, `git diff main...pr-42`, and writing a useful review.
