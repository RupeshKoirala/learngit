cd repo
printf 'n\ny\nn\n' | git add -p src/cart.js >/dev/null
git commit -q -m "Fix total for items without qty"
printf 'n\ny\n' | git add -p src/cart.js >/dev/null
git commit -q -m "Add clearCart helper"
