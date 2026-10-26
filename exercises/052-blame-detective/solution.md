# Solution

### 1–2. Who changed the threshold, and why?

```bash
git blame -L '/FREE_SHIPPING/,+1' src/shipping.js
# 1c2b2dc8 (release-bot ...) const FREE_SHIPPING_THRESHOLD = 5000;     <- useless

git log --oneline --grep=prettier                       # get the bot's hash, say 1c2b2dc
git blame --ignore-rev 1c2b2dc -L '/FREE_SHIPPING/,+1' src/shipping.js
# 14c55838 (Dev Patel ...) const FREE_SHIPPING_THRESHOLD = 5000;

git show 14c5583                                        # read the WHY
#   Raise free-shipping threshold to $50
#   Sam asked for this as part of the Q3 margin plan; finance signed off.
#   Refs: PRICING-88
git tag threshold-change 14c5583
echo PRICING-88 > ../ANSWER
```

So it *was* on purpose: tell Sam it's his own ticket. Blame finds the **who**, and the commit message holds the
**why**. That's the reason good commit messages and ticket references matter.

### 3. Who invented the express rate?

Peeling the onion one layer at a time:

```bash
git blame -L '/cart.express/,+1' src/shipping.js                     # release-bot (prettier)
git blame -L '/cart.express/,+1' 1c2b2dc^ -- src/shipping.js         # Jo: "Use 2-space indentation"
git blame -w -L '/cart.express/,+1' 1c2b2dc^ -- src/shipping.js      # Maya: "Extract shipping rules..."
git blame -w -C -L '/cart.express/,+1' 1c2b2dc^ -- src/shipping.js   # still Maya?!
git blame -w -C -L :shippingFor 1c2b2dc^ -- src/shipping.js          # Lena, in src/cart.js!
# 2dae38bb src/cart.js (Dev Patel   ...) function shippingFor(cart) {
# 2dae38bb src/cart.js (Dev Patel   ...)   if (total(cart) >= FREE_SHIPPING_THRESHOLD) return 0
# d536d8d8 src/cart.js (Lena Okafor ...)   return cart.express ? 1499 : 499
git tag express-origin d536d8d
```

Why did the one-line `-L` fail? `-C` only accepts a moved chunk with at least ~40 letters and digits, so it
doesn't confuse common one-liners like `return cart` with real moves. One short line is below that
threshold. Blame the whole function (`-L :shippingFor` uses the function name) or the whole file, and the
move becomes visible.

- `<rev>^ -- file` starts blame **from the parent** of a boring commit, so that commit can't be blamed.
- `-w` ignores whitespace, so Jo's re-indent is skipped.
- `-C` makes blame search the *other files changed in the same commit* for the lines. Maya's commit deleted
  them from `src/cart.js`, so blame keeps following them there. (`-C -C` also searches files that weren't
  changed in that commit, and `-C -C -C` searches every commit. Each step is slower. `-M` does the same for
  lines moved *within* one file.)

You might expect `git blame -w -C --ignore-rev 1c2b2dc` to do all of this in one go. Try it: it stops at
Maya's move. Lines passed through an ignored commit are re-matched one by one, so they reach the move as
single short lines, below the threshold above. **`--ignore-rev` is a heuristic.** When
the trail goes cold, restart from the parent.

### 4. Fix it for everyone

```bash
git rev-parse 1c2b2dc > .git-blame-ignore-revs      # must be the FULL hash
git add .git-blame-ignore-revs
git commit -m "Ignore the prettier reformat in git blame"
git config blame.ignoreRevsFile .git-blame-ignore-revs
git blame -L '/FREE_SHIPPING/,+1' src/shipping.js    # now shows Dev directly
```

**Why it works:** `blame.ignoreRevsFile` makes every `git blame` in this clone act as if those commits had
passed through the lines without changing them. The file is committed, so everyone gets the same list. The
config is per-clone, so each teammate runs the `git config` line once (put it in your onboarding docs or a
`make setup` target).

**Real-world notes**
- **GitHub reads `.git-blame-ignore-revs` automatically** in its web blame view. Committing the file
  pays off even for people who never touch the CLI.
- **Plan the reformat:** land a mass reformat as its own commit with *no* behaviour changes, then add its
  hash to `.git-blame-ignore-revs` in the very next commit. If you mix logic changes into a reformat, blame
  can't hide it without hiding the real change too.
- Don't use the ignore list to hide commits that changed behaviour. If someone runs a codemod that also fixed
  bugs, those fixes should stay blameable.
- `git log -L '/FREE_SHIPPING/,+1:src/shipping.js'` shows *every* change to a line, not only the last one.
  Use it when blame's one-commit answer isn't enough (exercise 058).
- On GitHub, "View blame prior to this change" is the web version of `git blame <rev>^ -- file`.
- Blame is for understanding, not for blaming. In a postmortem, "the threshold was raised under PRICING-88"
  helps the team. "Dev broke it" doesn't.
