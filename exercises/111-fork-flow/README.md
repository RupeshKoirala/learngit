# Open-source fork flow (safe)

You don't have write access to other people's repos. To contribute you **fork** (your own copy on GitHub),
clone the fork, keep it **in sync** with the original (**upstream**), and open PRs from a branch.

We practise on **`octocat/Spoon-Knife`**, GitHub's official repo for exactly this. To stay polite, **your PR
goes into your own fork's `main`, never to octocat** - no spam for the maintainers.

```
octocat/Spoon-Knife  (upstream, read-only for you)
        |  fork
<you>/Spoon-Knife    (origin, yours)
        |  clone
./Spoon-Knife        (local, in this exercise's sandbox)
```

## Your task

Run everything from this exercise's sandbox folder (`./lg where`).

1. Fork **and** clone in one command so you get `./Spoon-Knife` with **`origin` = your fork** and
   **`upstream` = octocat/Spoon-Knife**.
2. Keep your fork in sync: bring your fork's `main` up to date with upstream using **`gh repo sync`**, and pull
   it locally.
3. Create a branch (not `main`), make a small change (e.g. add a line to `README.md`), commit, push it to
   **your fork**, and open a PR **from that branch into your fork's `main`**.
4. You must have **no open PRs** to `octocat/Spoon-Knife`.

> **Careful:** `gh pr create` inside a fork clone defaults to the **upstream** repo. Always pass
> `--repo <you>/Spoon-Knife`, or run `gh repo set-default <you>/Spoon-Knife` first.

## You'll practice

`gh repo fork --clone`, remotes `origin`/`upstream`, `gh repo sync`, `git fetch upstream`, `gh repo set-default`,
`gh pr create --repo --base --head`, contribution etiquette.
