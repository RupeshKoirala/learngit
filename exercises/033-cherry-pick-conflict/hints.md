`git log --oneline main..release/3.1` lists the three candidates. You can pick the two fixes one by one,
or pick the whole range and drop the version bump when Git stops on it.
---
When the qty fix conflicts, `git status` shows `src/cart.js` as "both modified". Open it: between
`<<<<<<<` and `=======` is `main`'s code (HEAD), between `=======` and `>>>>>>>` is the fix's version. Don't
just choose one side — ask "what did the fix *mean*?" (`git show <fix-hash>`): use `qty || 1`.
---
The resolved function should look like this, and `total()` should keep using `map(lineTotal)`:
```js
function lineTotal(item) {
  return item.price * (item.qty || 1);
}
```
Remove all markers, then `git add src/cart.js` and `git cherry-pick --continue`.
---
If you picked the whole range (`git cherry-pick main..release/3.1`), Git also stops on `Release 3.1.1`
because `VERSION` conflicts. That commit doesn't belong on `main`: `git cherry-pick --skip` drops it and
carries on. Lost? `git cherry-pick --abort` resets everything to before you started.
