# Who owns what: find the experts, write CODEOWNERS

Brightcart is growing and PRs sit unreviewed for days because nobody knows who should look at them. Maya
asks you to set up GitHub's **`CODEOWNERS`**: GitHub then automatically requests reviews from the owners of
the files a PR touches (and, with branch protection, requires their approval).

GitHub handles:

| Person | Handle | | Team | Handle |
|---|---|---|---|---|
| Maya Chen (tech lead) | `@mayachen` | | maintainers | `@brightcart/maintainers` |
| Dev Patel | `@devpatel` | | platform | `@brightcart/platform` |
| Lena Okafor | `@lenaokafor` | | security | `@brightcart/security` |
| Sam Rivera (PM) | `@samrivera` | | database | `@brightcart/dba` |
| Jo Novak | `@jonovak` | | | |

## Your task

Create `.github/CODEOWNERS` on `main` and commit it. The team agreed on these rules:

1. By default, everything is owned by `@brightcart/maintainers`.
2. Each folder directly under `src/` (`checkout`, `catalog`, `search`) is owned by its **expert**: the person
   with the **most commits touching that folder** (count people, not email addresses — the repo has a `.mailmap`).
3. `src/checkout/payments/` is owned by the checkout expert **and** `@brightcart/security`.
4. `infra/` and `.github/workflows/` are owned by `@brightcart/platform`.
5. `docs/` is owned by `@samrivera`.
6. **Every** `.sql` file, wherever it is (even inside `src/checkout/`), is owned by `@brightcart/dba` only.
7. `.github/CODEOWNERS` itself is owned by `@mayachen`.

Remember how GitHub reads the file: for each changed file, the **last** matching line wins (owners are not
combined across lines). Files that aren't in any folder above, like `src/README.md`, stay with the maintainers.

## You'll practice

`git shortlog -sn -- <path>` (and `-e`), `.mailmap`, `git log --format=%aN` vs `%an`, CODEOWNERS pattern
syntax (`*`, `*.ext`, `/dir/`, `dir/`) and last-match-wins ordering.
