# Pickaxe search: who removed it, who changed it?

Two bug reports land on the same morning:

1. **Jo's old branch won't build.** It calls `applyCoupon(...)`, and that function no longer exists on `main`.
   Nobody remembers deleting it. Jo needs to know *which commit* removed it and what to call instead.
2. **Customers can't sign up with plus-addresses** like `anna+shop@example.com`. It used to work. The
   validation pattern `EMAIL_RE` in `src/validate.js` has been edited several times, and the API docs talk
   about it too, so `git log --grep` and scrolling through 30+ commits won't get you far.

`git blame` can't help with #1, because there's no line left to blame. You need the **pickaxe**: searching
history by what the *diffs* contain, not by commit messages.

```
* Refresh API docs
* ... 30-odd commits by five people ...
* Initial storefront
```

## Your task

In `repo` (don't change any branches or commits):

1. Tag the commit that **removed** the function `applyCoupon` as **`removed-applyCoupon`**.
2. In that commit the function didn't just vanish, it was replaced. Write the name of the function that
   replaces it (e.g. `fooBar`) into `ANSWER` in the sandbox folder (`../ANSWER` from `repo`).
3. Tag the commit that changed `EMAIL_RE` so that plus-addresses (`+` in the part before `@`) are rejected,
   as **`regex-change`**. Only commits to the code count, not to the docs.

## You'll practice

`git log -S<string>` (when did the *number of occurrences* change), `git log -G<regex>` (when did a line
matching the regex change), `-p` to read the diffs, limiting by path with `-- src/`, and the difference
between `-S` and `-G`.
