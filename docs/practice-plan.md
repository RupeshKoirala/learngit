# A practice plan

About 115 exercises. Most take 5–15 minutes; level-3 ones up to 30. You don't need to do them in one sitting.
Here's a sensible path. After each session, skim [recovery-playbook.md](recovery-playbook.md).

| Session | Exercises | Goal |
|---|---|---|
| 1 (~2 h) | Read [mental-model.md](mental-model.md), then 001–019 | Commits, staging, branches, merges and conflicts feel normal |
| 2 (~2 h) | 020–036 | Rebase and cherry-pick without fear |
| 3 (~2 h) | 037–051 | You can undo anything and rescue "lost" work |
| 4 (~2 h) | 052–071 | Investigate history like a detective; work with remotes and teammates |
| 5 (~2 h) | 072–090 | Handle real disasters; use the power tools |
| 6 (~2 h) | 091–099 + read [team-workflows.md](team-workflows.md) | Think like a lead / release manager |
| 7 (~3 h) | 100–115 | Do it all for real on GitHub with `gh` |

**Tips**

- Keep a second terminal open on `./lg graph` (or `git log --graph --oneline --all`) and re-run it after every
  command. Watching the pointers move is the whole trick — that's what makes Learn Git Branching work.
- Try each exercise *without* hints first. Use `./lg hint` one step at a time before `./lg solution`.
- Read every `solution.md` even when you solved it — the **Real-world notes** are where the senior-level
  lessons are.
- Break things on purpose. `./lg reset` gives you a fresh copy any time.
- Revisit: a week later, redo the level-3 exercises from memory.
