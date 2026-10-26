# Recover commits after an accidental reset --hard

You wanted to reword your last commit on `feature/reviews`, so you typed `git reset --soft HEAD~1`. Except
your fingers typed `git reset --hard HEAD~2`. You didn't notice, fixed a typo, and committed:

```
before                                     now
* Add review moderation queue              * Fix typo in reviews header      <- feature/reviews
* Add star rating widget                   * Add review form
* Add review form                          * Add reviews page skeleton
* Add reviews page skeleton                * Initial storefront               <- main
* Initial storefront   <- main
```

Then you noticed `src/reviews/rating.js` and `src/reviews/moderation.js` had vanished. Two commits of work,
gone from the branch, never pushed.

## Your task

On `feature/reviews`, get back **both** lost commits ("Add star rating widget" and "Add review moderation
queue") **and** keep your new "Fix typo in reviews header" commit.

- All three commit messages must be in the branch's history, and all files present with their content.
- Keep the earlier two commits as they are; `main` must not change.
- Finish with a clean working tree and nothing in progress.

## You'll practice

`git reflog` / `git log -g` to find "lost" commits, `ORIG_HEAD`, `git cherry-pick` of a range, and
`git reset --hard <reflog-entry>` as an undo button for history moves.
