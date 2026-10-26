cd repo
git restore --staged src/cart.js
git commit -q -m "Fix rounding in formatPrice"
git add src/cart.js README.md
git commit -q -m "Add removeItem to cart"
