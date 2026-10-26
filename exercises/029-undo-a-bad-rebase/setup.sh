returns_js() {   # returns_js <days>
  write src/returns.js "// Returns policy" "const RETURN_WINDOW_DAYS = $1;" "" "function canReturn(order, today) {" "  return (today - order.deliveredOn) / 86400000 <= RETURN_WINDOW_DAYS;" "}" "" "module.exports = { canReturn, RETURN_WINDOW_DAYS };"
}

new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/returns
as you
returns_js 14
commit "Add returns policy module"
returns_js 30
append README.md "" "Returns: accepted within 30 days of delivery."
commit "Extend the return window to 30 days"
write src/fees.js "// Restocking fee for opened items (in cents)" "function restockingFee(item) {" "  return item.opened ? Math.round(item.price * 0.15) : 0;" "}" "" "module.exports = { restockingFee };"
commit "Charge a restocking fee for opened items"
remember original

git switch -q main
day
as lena; append README.md "" "Shipping: orders ship within 2 business days."
commit "Document shipping times"

# Late at night, you rebase... and panic at the README conflict.
git switch -q feature/returns
day
as you
git rebase main >/dev/null 2>&1 || true
git rebase --skip >/dev/null 2>&1          # oops: that threw away the whole 30-day commit
git reset -q --hard HEAD                   # "just to be sure everything is clean" (this also moves ORIG_HEAD)
remember bad
