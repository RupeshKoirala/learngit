cd repo
git add src/giftcard.js
git commit -q --fixup ':/Add gift card model'
git add src/checkout.js
git commit -q --fixup "$(git log --format=%h --grep='^Redeem gift cards at checkout$' main..HEAD)"
git config rebase.autoSquash true
GIT_SEQUENCE_EDITOR=true git rebase -q -i --autosquash main
