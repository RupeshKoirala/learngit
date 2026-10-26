cd repo
git restore src/price.js
git restore --staged src/cart.js
git clean -q -f -d -e src/coupon.js
