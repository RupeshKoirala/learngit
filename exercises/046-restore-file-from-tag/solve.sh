cd repo
git restore --source=v1.2.0 src/price.js
git add src/price.js
git commit -q -m "Restore v1.2.0 price formatting"
