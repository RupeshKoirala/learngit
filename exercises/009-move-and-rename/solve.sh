cd repo
mkdir -p src/cart src/utils scripts
git mv src/cart.js src/cart/cart.js
git mv src/price.js src/utils/format-price.js
git mv test.sh scripts/test.sh
git commit -q -m "Reorganize source folders"
replace README.md "\.\/test\.sh" ".\/scripts\/test.sh"
git commit -q -am "Update test command in README"
git log --follow --format=%h -- src/utils/format-price.js | tail -1 > ../ANSWER
