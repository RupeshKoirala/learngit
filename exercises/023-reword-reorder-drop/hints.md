First see what each commit touches: `git log --stat --oneline main..`. Then `git rebase -i main` opens the todo
list, **oldest commit at the top** (the opposite of `git log`).
---
In the todo list: `reword` (`r`) keeps a commit but lets you change its message; `drop` (`d`) — or simply
deleting the line — removes a commit; and moving a line moves the commit. Lines run top to bottom.
---
Make the todo list look like this (your hashes differ):

```
reword 1111111 asdf
reword 4444444 add btn
pick   2222222 Document the wishlist
drop   3333333 temp debug
```

Save and close. Git then opens your editor once per `reword` — replace the old message with the new one.
---
Rewording got typo'd, or a step went wrong? `git rebase --abort` during the rebase, or `git reset --hard
ORIG_HEAD` right after it, and try again. You can also fix just the newest commit's message later with
`git commit --amend`.
