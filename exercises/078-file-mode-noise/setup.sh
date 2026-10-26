# Lena's "format" commit flipped every file to 100755. Meanwhile test.sh was never executable in Git (100644).
new_repo repo
git config core.fileMode true
brightcart_skeleton
chmod 644 test.sh                 # committed from a Windows machine long ago: not executable in Git
as maya; commit "Initial storefront"
as dev;  write docs/setup.md "# Setup" "" "Run ./test.sh" ; write docs/style.md "# Style" "" "2 spaces, semicolons."
         commit "Add setup and style docs"
as lena
chmod 755 README.md .gitignore src/cart.js src/price.js docs/setup.md docs/style.md
replace src/cart.js "  cart.items.push\(item\);" "  cart.items.push(item);  \/\/ mutates on purpose"
commit "Format cart code"
as you
remember original
