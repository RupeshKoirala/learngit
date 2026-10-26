# Your first repository: init, identity, first commits

Brightcart just hired you. Maya (tech lead) hands you a zip of the storefront prototype she hacked together
on her laptop: "It was never in Git. Put it under version control so the team can start working on it — and
please don't commit my secrets or 40 MB of `node_modules`."

The folder `shop/` looks like this:

```
shop/
├── .env               <- real secrets (never commit!)
├── .env.example       <- template for .env, SHOULD be committed
├── README.md
├── node_modules/      <- installed dependencies (never commit)
├── npm-debug.log      <- log noise (never commit)
├── package.json
├── src/cart.js
├── src/price.js
└── test.sh
```

It is **not** a Git repository yet — `git status` will tell you so.

## Your task

Inside `shop/`:

1. Turn the folder into a Git repository whose branch is called **`main`**.
2. Set your name and email **for this repository only** (not `--global`) — the way you would on a client
   project where you use a different email.
3. Create a `.gitignore` so that `node_modules/`, `.env` and any `*.log` file are ignored — but
   `.env.example` is **not** ignored.
4. Commit everything else (at least one commit; two is nicer: `.gitignore` first, then the project).
5. Finish with a clean working tree: `git status` says *nothing to commit*.

`node_modules/`, `.env` and `npm-debug.log` must never appear in any commit — but leave them on disk;
the app still needs them.

## You'll practice

`git init -b main`, `git config` (local vs global), `.gitignore`, `git status`, `git add`, `git commit`,
`git log --oneline --stat`, and checking what you're about to commit *before* you commit it.
