# Writing an exercise

Every exercise is a folder `exercises/NNN-short-slug/` containing:

| File | Purpose |
|---|---|
| `meta` | `title=…`, `module=NN · Module name`, `level=1..3` (1 = basic, 3 = senior), optional `workdir=` (default `repo`), optional `needs=gh filter-repo`, optional `ci=skip` (only GitHub-track exercises) |
| `setup.sh` | Builds the scenario inside an empty sandbox directory (`$LG_DIR`). Runs with `lib/setup.sh` already sourced. |
| `README.md` | The task, shown by `./lg start`. Story → current state (small ASCII graph) → **Your task** (precise, checkable) → **You'll practice**. |
| `hints.md` | 3–4 hints separated by lines containing only `---`, from a nudge to almost the answer. |
| `check.sh` | Verifies the result. Runs with `lib/check.sh` sourced and cwd = `$LG_DIR`. Use `in_repo` then `expect "…" predicate args`, end with `finish`. |
| `solution.md` | Worked solution with commands, **why it works**, and **real-world notes** (what a senior dev / lead would do, gotchas). |
| `solve.sh` | Automated solution used by `test/run-all.sh` (CI). Runs with `lib/setup.sh` sourced, cwd = `$LG_DIR`, `GIT_EDITOR=true`. For interactive rebases use `GIT_SEQUENCE_EDITOR="cp <todo-file>"`. |
| `event.sh` (optional) | A "meanwhile, a teammate…" action the learner triggers with `./lg event` mid-exercise. Same environment as setup.sh. |

## Rules

- **Portable shell.** Scripts run under bash 3.2 (macOS `/bin/bash`) and git 2.30+. No associative arrays,
  `${x,,}`, `mapfile`, `sed -i`, `readarray`, `declare -A`, GNU-only flags (`grep -P`, `date -d`, `stat -c`,
  `sed -r`, `xargs -r`, `head -c` is ok). Use the `replace` helper (perl) for in-place edits.
- **Deterministic.** Use the helpers: `new_repo`, `new_bare`, `write`, `append`, `replace`, `commit`, `tick`,
  `day`, `as <you|maya|dev|lena|sam|jo|bot>`, `brightcart_skeleton`, `remember <name> [rev]`.
  Fake remotes are bare repos at `$LG_DIR/remotes/<name>.git`; add them as `origin` with a relative or absolute
  path. Teammates' work is created through a second clone such as `$LG_DIR/.team/<name>` (dot-folders keep the
  sandbox tidy).
- **The check must fail right after setup and pass after solve.sh.** `test/run-all.sh` enforces this.
- **Check the result, not the keystrokes.** Accept every valid way to solve it (e.g. squash vs fixup vs reset
  --soft). Never require specific hashes the learner can't know. For "find something" tasks, ask the learner
  to create a tag or write a hash/word into `$LG_DIR/ANSWER` (see `answer_is`, `answer_commit_is`).
- **Each requirement is one `expect` line** with a description that reads as a goal ("main still points at …").
- **No real company or employer names.** The fictional company is *Brightcart*, an online store.
- Put any helper you need inside your own scripts (function definitions at the top). Don't edit `lib/`.
- Run `test/run-all.sh <number>` until it says `ok`.
