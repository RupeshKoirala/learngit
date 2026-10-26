Bisect needs one known-bad and one known-good commit, then it checks out the commit halfway between them:
```bash
git bisect start
git bisect bad main
git bisect good v1.4
```
(Shortcut: `git bisect start main v1.4`, bad first, then good.)
---
Now judge the commit Git checked out: `cat ui/checkout.txt`. Is the `[ Place order ]` button inside the card
or hanging off the right edge? Answer with `git bisect good` or `git bisect bad`. Git halves the range and
checks out the next commit. Repeat.
---
Made a wrong call? `git bisect log > ../bisect.log`, delete the bad line(s) from that file, then
`git bisect reset` and `git bisect replay ../bisect.log`. Lost? `git bisect visualize --oneline` shows the
commits still in play.
---
When Git prints `<hash> is the first bad commit`, tag it **before** you reset (the hash is also kept as
`refs/bisect/bad` until then):
```bash
git tag first-bad refs/bisect/bad     # or: git tag first-bad <hash>
git bisect reset                      # ends the session and returns to main
```
