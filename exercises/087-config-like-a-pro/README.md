# Config like a pro: aliases, conditional includes, --show-origin

Two config annoyances in one morning:

1. Maya: *"Your last commit to the storefront is authored by `you@personal.example`. Work repos need your
   work email."* You keep forgetting to switch.
2. You set `pull.rebase = true` globally months ago, yet `git pull` in the storefront keeps creating merge
   commits. Something somewhere overrides it.

Also, everyone on the team has a `git lg` that draws the graph, and a `git undo`. Time to get yours.

**Sandbox layout.** So we never touch your real `~/.gitconfig`, the file **`gitconfig`** at the top of the
sandbox plays the role of your global config. Every sandbox repo already includes it (`include.path`).
Edit it with `git config --file ../../gitconfig …` from `work/storefront` (or open it in an editor).

```
<sandbox>/
├── gitconfig            <- your "global" config (user.email = you@personal.example)
├── work/storefront/     <- work repo (you are here)
└── oss/dotfiles/        <- personal project, must keep the personal email
```

## Your task

1. In the sandbox **`gitconfig`**, add two aliases:
   - **`lg`**: a one-line-per-commit **graph of all branches** with branch/tag names
     (`git lg` must show `feature/gift-cards` even while you're on `main`).
   - **`undo`**: undo the last commit but **keep its changes staged**.
2. Create **`gitconfig-work`** next to `gitconfig` setting `user.email = you@brightcart.example`, and make
   `gitconfig` load it **only for repos under `work/`** with an `includeIf "gitdir:…"` section.
   `oss/dotfiles` must keep `you@personal.example`. Don't set `user.email` in the repo's own config.
3. Find out where the storefront's `pull.rebase = false` comes from with **`--show-origin`** and remove it so
   your "global" `true` wins.
4. Fix the authorship of your last storefront commit (`docs: mention currency`) to the work email, keeping
   its message and content.

## You'll practice

`git config` scopes (system / global / local / worktree / command line), `--show-origin` and `--show-scope`,
`[alias]`, `include.path`, `includeIf "gitdir:"`, and `git commit --amend --reset-author`.
