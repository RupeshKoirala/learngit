cd repo
git switch -q -c release/2.0 ':/code freeze for 2.0.0'
replace src/checkout.js "TAX_RATE = 0\.8;" "TAX_RATE = 0.08;"
commit "fix(checkout): tax rate is 8%, not 80% (BC-201)"
replace src/price.js "toFixed\(1\)" "toFixed(2)"
commit "fix(price): show two decimals (BC-202)"
./test.sh >/dev/null
git tag -a v2.0.0 -m "Brightcart 2.0.0"
git switch -q main
git merge -q --no-ff -m "Merge branch 'release/2.0'" release/2.0
git push -q --follow-tags origin main release/2.0
