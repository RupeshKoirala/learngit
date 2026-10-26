cd repo
P=$(git log --format=%H -1 --grep='^Format all code with prettier')

# 1+2: blame past the reformat, read the commit message
T=$(git blame --porcelain --ignore-rev "$P" -L '/FREE_SHIPPING_THRESHOLD =/,+1' -- src/shipping.js | head -1 | cut -d' ' -f1)
git tag threshold-change "$T"
git show -s --format=%B "$T" | sed -n 's/^Refs: //p' > ../ANSWER

# 3: restart before the bot; -w skips the re-indent, -C follows the move out of cart.js
E=$(git blame -w -C -l -s -L :shippingFor "$P^" -- src/shipping.js | grep "cart.express" | cut -d" " -f1)
git tag express-origin "$E"

# 4: team-wide ignore list
printf '%s\n' "# Mass reformat: prettier (no behaviour change)" "$P" > .git-blame-ignore-revs
git add .git-blame-ignore-revs
commit "Ignore the prettier reformat in git blame"
git config blame.ignoreRevsFile .git-blame-ignore-revs
