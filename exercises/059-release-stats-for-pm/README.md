# Release stats for your PM

Release **v2.1** shipped last week. Sam (PM) is writing the release retro and the quarterly update for
leadership, and asks you for some numbers:

> 1. Who contributed most to 2.1? I want to thank them by name.
> 2. How many commits went into 2.1 in total?
> 3. We had a planning week at the end of February. How many 2.1 commits landed **on or after March 1st**
>    (2025-03-01)?
> 4. Which file changed in the most commits? I suspect checkout is our hot spot. That's where we should
>    invest in tests.

First try: `git shortlog -sn v2.0..v2.1` says Lena is the top contributor. But Dev looks confused: he
committed a lot from his home laptop, where his Git identity is `Dev P. <dev.patel@home.example>`. Git
counts him as two people. Before you send numbers to leadership, fix that properly for the whole team with a
**`.mailmap`** file.

```
* (main) Next: search filters (6)       <- after the release, doesn't count
* ...
* (tag: v2.1) Checkout: handle edge case #48
* ... 48 commits by Lena, Dev (x2 identities), Maya, Jo ...
* (tag: v2.0) Release 2.0
* ...
```

## Your task

In `repo`:

1. Create a **`.mailmap`** that maps `Dev P. <dev.patel@home.example>` to his canonical identity
   `Dev Patel <dev@brightcart.example>`, and **commit** it on `main`.
2. Write your answers for Sam into `../ANSWER`, one `key=value` per line:
   ```
   top=<name of the top contributor for v2.0..v2.1, after merging identities>
   commits=<total number of commits in v2.0..v2.1>
   since=<number of v2.0..v2.1 commits made on or after 2025-03-01>
   hotfile=<path of the file changed in the most commits in v2.0..v2.1>
   ```

Count only what's between the two tags: the work after v2.1 doesn't belong in this release.

## You'll practice

`git shortlog -sne <range>`, `.mailmap` and `git check-mailmap`, `git log --since/--until`,
`git rev-list --count`, and `git log --name-only --format=` piped through `sort | uniq -c | sort -rn`.
