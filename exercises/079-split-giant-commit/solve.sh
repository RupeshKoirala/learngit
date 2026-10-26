cd repo
BIG=feature/checkout-revamp
git switch -q -c feature/tax main
git checkout "$BIG" -- src/tax.js src/tax-rates.js
git commit -q -m "Add sales tax by region"
git switch -q -c feature/shipping
git checkout "$BIG" -- src/shipping.js src/shipping-zones.js
git commit -q -m "Add shipping cost by postcode zone"
git switch -q -c feature/checkout-ui
git checkout "$BIG" -- .
git commit -q -m "Add checkout summary UI"
