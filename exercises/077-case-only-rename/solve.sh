cd repo
git mv -f readme.md README.md
git mv src/Utils.js src/utils.tmp
git mv src/utils.tmp src/utils.js
replace src/cart.js "require\('\.\/Utils'\)" "require('.\/utils')"
git commit -q -am "Normalize file name casing (README.md, src/utils.js)"
