cd repo
git merge -q --no-edit -X find-renames=40% main
replace src/sale-banner.js "require\('\.\/price'\)" "require('.\/utils\/money')"
git commit -q -am "Point sale banner at src/utils/money.js"
