new_repo repo
brightcart_skeleton
write templates/checkout.html \
  "<section class=\"checkout\">" \
  "  <img src=\"/img/cart.png\">" \
  "  <h1>Your cart</h1>" \
  "  <ul id=\"items\"></ul>" \
  "" \
  "  <p class=\"total\"></p>" \
  "" \
  "  <button class=\"remove\">x</button>" \
  "  <button class=\"pay\">Pay</button>" \
  "</section>"
write styles/base.css "body { font-family: sans-serif; }" "" "button:focus { outline: 1px dotted #ccc; }"
as maya; commit "Initial storefront"
as dev;  append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
         commit "Add removeItem to cart"
as bot;  write VERSION "2.0.0"; commit "Release 2.0.0"
git branch release/2.0

as dev;  write src/stock.js "// Stock levels" "function inStock(item) { return item.stock > 0; }" "module.exports = { inStock };"
         commit "Add stock check"

# Lena's redesign branch: 3 accessibility fixes in the middle of design work
git switch -q -c feature/checkout-redesign
as lena
write styles/redesign.css ".checkout { display: grid; gap: 1rem; }"
commit "Redesign: grid layout for checkout"
append styles/redesign.css ".checkout h1 { font-size: 2.5rem; letter-spacing: -0.02em; }"
commit "Redesign: bigger headings"
replace templates/checkout.html '<img src="\/img\/cart.png">' '<img src="\/img\/cart.png" alt="Shopping cart">'
commit "a11y: add alt text to cart image"
replace templates/checkout.html '<button class="remove">x<\/button>' '<button class="remove" aria-label="Remove item">x<\/button>'
commit "a11y: label the remove-item button"
replace styles/base.css 'outline: 1px dotted #ccc;' 'outline: 3px solid #1a5fb4;'
commit "a11y: visible focus outline"
append styles/redesign.css ".checkout .pay { background: linear-gradient(90deg, #ff5f6d, #ffc371); }"
commit "Redesign: gradient pay button (DO NOT SHIP yet)"
remember redesign
git switch -q main
remember main
remember release release/2.0
as you

# Work out the expected end states in a throwaway clone (so the learner's repo has no extra refs).
_tmp="$LG_DIR/.lg/tmp"; rm -rf "$_tmp"; git clone -q . "$_tmp"
(
  cd "$_tmp"
  _first=$(git log --reverse --format=%H --grep='^a11y:' origin/feature/checkout-redesign | head -1)
  _last=$(git log --format=%H --grep='^a11y:' origin/feature/checkout-redesign | head -1)
  git switch -q -c r origin/release/2.0; git cherry-pick "$_first^..$_last" >/dev/null
  git rev-parse HEAD^{tree} > "$LG_DIR/.lg/release_expected.tree"
  git switch -q main; git cherry-pick -n "$_first^..$_last" >/dev/null
  git write-tree > "$LG_DIR/.lg/main_expected.tree"
)
rm -rf "$_tmp"
